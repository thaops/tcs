import 'dart:convert';
// Nếu dự án của bạn dùng Operation từ fleather:
import 'package:fleather/fleather.dart' show Operation;
// Nếu dự án dùng Operation từ quill_delta, thay import ở trên bằng:
// import 'package:quill_delta/quill_delta.dart' show Operation;

class BlocknoteConverter {
  static const String _zwsp = '\u200B'; // zero-width space để giữ dòng trống
  static List<Map<String, dynamic>> _tableBlocks = [];
  // Debug flag
  static bool debug = true; // set false to silence
  static void _log(String msg) {
    if (debug) {
      // ignore: avoid_print
      print('[BlocknoteConverter] ' + msg);
    }
  }

  /// Decode input thành List blocks (blocknote JSON)
  static List<dynamic> _decodeBlocks(dynamic input) {
    _log('decode input type=${input?.runtimeType}');
    if (input == null) return <dynamic>[];
    if (input is List) return input;
    if (input is String) {
      final s = input.trim();
      if (s.isEmpty) return <dynamic>[];
      try {
        final decoded = jsonDecode(s);
        if (decoded is List) {
          _log('decoded String -> List, len=${decoded.length}');
          return decoded;
        }
        if (decoded is Map) {
          final desc = decoded['description'];
          if (desc is String) {
            try {
              final inner = jsonDecode(desc);
              if (inner is List) {
                _log('decoded Map.description String -> List, len=${inner.length}');
                return inner;
              }
              _log('Map.description String decoded but not List');
              return <dynamic>[];
            } catch (_) {
              _log('fail to jsonDecode Map.description String');
              return <dynamic>[];
            }
          }
          if (desc is List) {
            _log('decoded Map.description is List, len=${desc.length}');
            return desc;
          }
        }
      } catch (_) {
        _log('jsonDecode failed for String input');
        return <dynamic>[];
      }
      return <dynamic>[];
    }
    if (input is Map) {
      final desc = input['description'];
      if (desc is String) {
        try {
          final inner = jsonDecode(desc);
          if (inner is List) {
            _log('Map input -> description String -> List, len=${inner.length}');
            return inner;
          }
          _log('Map input -> description String decoded but not List');
          return <dynamic>[];
        } catch (_) {
          _log('Map input -> description String jsonDecode failed');
          return <dynamic>[];
        }
      }
      if (desc is List) {
        _log('Map input -> description is List, len=${desc.length}');
        return desc;
      }
    }
    return <dynamic>[];
  }

  /// Helpers cho fleather/quill Delta (đọc được cả Operation lẫn Map)
  static bool _isInsert(dynamic op) {
    if (op is Operation) return op.isInsert;
    return op is Map && op.containsKey('insert');
  }

  static dynamic _val(dynamic op) {
    if (op is Operation) return op.value;
    return (op as Map)['insert'];
  }

  static Map<String, dynamic>? _attrs(dynamic op) {
    if (op is Operation) {
      final a = op.attributes;
      if (a == null) return null;
      return Map<String, dynamic>.from(a);
    }
    if (op is Map && op['attributes'] is Map) {
      return Map<String, dynamic>.from(op['attributes'] as Map);
    }
    return null;
  }

  /// Build inline node (text/link) từ một insert op
  static Map<String, dynamic> _inlineFromOp(dynamic op, String text) {
    final a = _attrs(op) ?? <String, dynamic>{};
    final styles = <String, dynamic>{};
    if (a['b'] == true) styles['bold'] = true;
    if (a['i'] == true) styles['italic'] = true;
    final textNode = {'type': 'text', 'text': text, 'styles': styles};

    final href = a['a'];
    if (href is String && href.isNotEmpty) {
      return {'type': 'link', 'href': href, 'content': [textNode]};
    }
    return textNode;
  }

  /// Map styles Blocknote -> attributes Fleather (bold/italic)
  static Map<String, dynamic>? _attrsFromBlockStyles(Map<String, dynamic>? styles) {
    if (styles == null) return null;
    final out = <String, dynamic>{};
    if (styles['bold'] == true || styles['fontWeight'] == 'bold') out['b'] = true;
    if (styles['italic'] == true || styles['fontStyle'] == 'italic') out['i'] = true;
    return out.isEmpty ? null : out;
  }

  /// Xoá attributes null/rỗng cho chuẩn Delta
  static void _cleanupDeltaOps(List<Map<String, dynamic>> ops) {
    for (final op in ops) {
      final a = op['attributes'];
      if (a == null) {
        op.remove('attributes');
      } else if (a is Map) {
        a.removeWhere((k, v) => v == null);
      }
    }
  }

  static List<Map<String, dynamic>> blocknoteToFleatherDelta(dynamic blocknoteJsonOrString) {
    final blocks = _decodeBlocks(blocknoteJsonOrString);
    _log('blocknoteToFleatherDelta blocks=${blocks.length}');
    _tableBlocks = [];
    final deltaOps = <Map<String, dynamic>>[];

    void emitSpan(String text, {bool bold = false, bool italic = false, String? href}) {
      final attrs = <String, dynamic>{};
      if (bold) attrs['b'] = true;
      if (italic) attrs['i'] = true;
      if (href != null && href.isNotEmpty) attrs['a'] = href;
      final op = <String, dynamic>{'insert': text};
      if (attrs.isNotEmpty) op['attributes'] = attrs;
      deltaOps.add(op);
    }

    void emitContentSpans(dynamic content) {
      if (content is! List) return;
      for (final item in content) {
        try {
          if (item is! Map) continue;
          if (item['type'] == 'text' && item['text'] != null) {
            final styles = (item['styles'] is Map)
                ? Map<String, dynamic>.from(item['styles'])
                : <String, dynamic>{};
            final bold = styles['bold'] == true || styles['fontWeight'] == 'bold';
            final italic = styles['italic'] == true || styles['fontStyle'] == 'italic';
            emitSpan(item['text'] as String, bold: bold, italic: italic);
          } else if (item['type'] == 'link' && item['href'] is String) {
            final href = item['href'] as String;
            final linkContent = (item['content'] is List) ? List.from(item['content']) : const [];
            for (final linkItem in linkContent) {
              try {
                if (linkItem is Map && linkItem['type'] == 'text' && linkItem['text'] != null) {
                  final styles = (linkItem['styles'] is Map)
                      ? Map<String, dynamic>.from(linkItem['styles'])
                      : <String, dynamic>{};
                  final bold = styles['bold'] == true || styles['fontWeight'] == 'bold';
                  final italic = styles['italic'] == true || styles['fontStyle'] == 'italic';
                  emitSpan(linkItem['text'] as String, bold: bold, italic: italic, href: href);
                }
              } catch (_) {
                continue;
              }
            }
          }
        } catch (_) {
          continue;
        }
      }
    }

    for (final raw in blocks) {
      try {
        if (raw is! Map) {
          _log('skip non-Map block type=${raw.runtimeType}');
          continue;
        }
        final type = raw['type'];
        _log('process block type=$type');
        final content = raw['content'] ?? [];
        final props = (raw['props'] is Map) ? Map<String, dynamic>.from(raw['props']) : <String, dynamic>{};
        final blockAttrs = _attrsFromBlockStyles(props['styles'] is Map ? Map<String, dynamic>.from(props['styles']) : null);

        if (type == 'paragraph') {
          final before = deltaOps.length;
          emitContentSpans(content);
          if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
          deltaOps.add({'insert': '\n', if (blockAttrs != null) 'attributes': blockAttrs});
          continue;
        }

        if (type == 'checkListItem') {
          final before = deltaOps.length;
          emitContentSpans(content);
          if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
          final checkedRaw = props['checked'];
          final checked = (checkedRaw == true) || (checkedRaw == 'true') || (checkedRaw == 1);
          deltaOps.add({
            'insert': '\n',
            'attributes': {
              'block': 'cl',
              'checked': checked,
            }
          });
          continue;
        }

        if (type == 'heading') {
          final before = deltaOps.length;
          emitContentSpans(content);
          if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
          final rawLevel = props['level'];
          final level = (rawLevel is int) ? rawLevel : (rawLevel is num) ? rawLevel.toInt() : 1;
          deltaOps.add({'insert': '\n', 'attributes': {'header': level}});
          continue;
        }

        if (type == 'bulletListItem') {
          final before = deltaOps.length;
          emitContentSpans(content);
          if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
          // Fleather expects block list style via 'block': 'ul'
          deltaOps.add({'insert': '\n', 'attributes': {'block': 'ul'}});
          continue;
        }

        if (type == 'numberedListItem' || type == 'orderedListItem') {
          final before = deltaOps.length;
          emitContentSpans(content);
          if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
          // Fleather expects block ordered list via 'block': 'ol'
          deltaOps.add({'insert': '\n', 'attributes': {'block': 'ol'}});
          continue;
        }

        if (type == 'blockquote') {
          final before = deltaOps.length;
          emitContentSpans(content);
          if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
          deltaOps.add({'insert': '\n', 'attributes': {'blockquote': true}});
          continue;
        }

        if (type == 'codeBlock') {
          final before = deltaOps.length;
          emitContentSpans(content);
          if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
          deltaOps.add({'insert': '\n', 'attributes': {'code-block': true}});
          continue;
        }

        if (type == 'image' && props['link'] != null) {
          Map<String, dynamic>? imageAttrs =
              (props['styles'] is Map) ? Map<String, dynamic>.from(props['styles']) : null;
          // chỉ để width/height nếu có
          if (imageAttrs != null) {
            imageAttrs.removeWhere((k, v) => !['width', 'height'].contains(k));
          }
          deltaOps.add({
            'insert': {'image': props['link']},
            if (imageAttrs != null) 'attributes': imageAttrs,
          });
          deltaOps.add({'insert': '\n'});
          continue;
        }

        if (type == 'file') {
          final name = (props['name'] as String?)?.trim();
          final url = (props['url'] as String?)?.trim() ?? '';
          // Emit: "Document: " + linked filename (if url available)
          deltaOps.add({'insert': 'Document: '});
          if (url.isNotEmpty) {
            final op = <String, dynamic>{'insert': name?.isNotEmpty == true ? name! : url};
            op['attributes'] = {'a': url};
            deltaOps.add(op);
          } else {
            deltaOps.add({'insert': name?.isNotEmpty == true ? name! : ''});
          }
          // Normal newline without custom attributes
          deltaOps.add({'insert': '\n', if (blockAttrs != null) 'attributes': blockAttrs});
          continue;
        }

        if (type == 'table') {
          _tableBlocks.add(Map<String, dynamic>.from(raw));
          continue;
        }

        // fallback paragraph
        final before = deltaOps.length;
        emitContentSpans(content);
        if (deltaOps.length == before) deltaOps.add({'insert': _zwsp});
        deltaOps.add({'insert': '\n', if (blockAttrs != null) 'attributes': blockAttrs});
      } catch (e) {
        _log('caught error in block processing: ' + e.toString());
        // skip malformed block
        continue;
      }
    }

    _cleanupDeltaOps(deltaOps);
    _log('deltaOps count=${deltaOps.length}');
    if (deltaOps.isEmpty) {
      _log('delta empty -> use plain text fallback');
      // Best-effort plain text fallback so that something renders
      return _plainTextOpsFromBlocks(blocks);
    }
    return deltaOps;
  }

  // Fallback: build a simple plain-text Delta from blocks when rich conversion fails
  static List<Map<String, dynamic>> _plainTextOpsFromBlocks(List<dynamic> blocks) {
    final ops = <Map<String, dynamic>>[];
    String buffer = '';
    void flush() {
      if (buffer.isNotEmpty) {
        ops.add({'insert': buffer});
        buffer = '';
      }
    }

    for (final raw in blocks) {
      try {
        if (raw is! Map) continue;
        final type = raw['type'];
        final content = raw['content'];
        if (content is List) {
          for (final item in content) {
            try {
              if (item is Map) {
                if (item['type'] == 'text' && item['text'] is String) {
                  buffer += (item['text'] as String);
                } else if (item['type'] == 'link') {
                  final inner = item['content'];
                  if (inner is List) {
                    for (final t in inner) {
                      if (t is Map && t['type'] == 'text' && t['text'] is String) {
                        buffer += (t['text'] as String);
                      }
                    }
                  }
                }
              }
            } catch (_) {
              continue;
            }
          }
        }
        // Put a newline per block to preserve structure
        buffer += '\n';
        // For lists/checkboxes add one more newline to mimic spacing
        if (type == 'bulletListItem' || type == 'numberedListItem' || type == 'orderedListItem' || type == 'checkListItem') {
          buffer += '\n';
        }
      } catch (_) {
        continue;
      }
    }
    flush();
    // Ensure at least one newline to make a valid paragraph
    if (ops.isEmpty) {
      ops.add({'insert': '\n'});
    }
    return ops;
  }

  /// FLEATHER DELTA -> BLOCKNOTE
  /// - deltaOps có thể là List<Operation> hoặc List<Map> (toJson())
  /// - originalJson (tuỳ chọn) để giữ nguyên id/props cũ nếu có
  static List<dynamic> fleatherDeltaToBlocknote(List<dynamic> deltaOps, dynamic originalJsonOrString) {
    final originalBlocks = _decodeBlocks(originalJsonOrString);
    final blocknoteJson = <dynamic>[];
    _tableBlocks = _tableBlocks; // giữ lại nếu đã có từ lần convert trước
    int blockIndex = 0;

    Map<String, dynamic> _defaultProps([Map? from]) {
      if (from != null) return Map<String, dynamic>.from(from);
      return {'textColor': 'default', 'backgroundColor': 'default', 'textAlignment': 'left'};
    }

    for (var i = 0; i < deltaOps.length; i++) {
      try {
        final op = deltaOps[i];
        if (!_isInsert(op)) continue;

        final v = _val(op);
        final a = _attrs(op) ?? <String, dynamic>{};

        // 1) Inline text (không phải newline)
        if (v is String && v != '\n') {
          final originalBlock =
              blockIndex < originalBlocks.length ? originalBlocks[blockIndex] : null;
          final blockId = (originalBlock is Map && originalBlock['id'] != null)
              ? originalBlock['id']
              : 'id_${DateTime.now().millisecondsSinceEpoch}_$blockIndex';
          Map<String, dynamic> props =
              _defaultProps(originalBlock is Map ? originalBlock['props'] as Map? : null);

          // paragraph-level styles tạm ánh xạ từ op đầu tiên
          if (a['b'] == true) (props['styles'] ??= {})['fontWeight'] = 'bold';
          if (a['i'] == true) (props['styles'] ??= {})['fontStyle'] = 'italic';

          final contentSpans = <Map<String, dynamic>>[];
          if (v != _zwsp) contentSpans.add(_inlineFromOp(op, v));

          // gom tiếp các insert string cho đến khi gặp newline
          int j = i + 1;
          dynamic newlineOp;
          while (j < deltaOps.length) {
            final nxt = deltaOps[j];
            if (_isInsert(nxt)) {
              final nv = _val(nxt);
              if (nv is String && nv != '\n') {
                if (nv != _zwsp) contentSpans.add(_inlineFromOp(nxt, nv));
                j++;
                continue;
              }
              if (nv == '\n') newlineOp = nxt;
            }
            break;
          }

          Map<String, dynamic> _mkBlock(String type, {Map<String, dynamic>? extraProps}) => {
                'id': blockId,
                'type': type,
                'props': {...props, ...?extraProps},
                'content': contentSpans,
                'children': [],
              };

          final na = _attrs(newlineOp) ?? {};

          if (newlineOp != null && na['block'] == 'cl') {
            blocknoteJson.add(_mkBlock('checkListItem', extraProps: {'checked': na['checked'] ?? false}));
            i = j;
          } else if (newlineOp != null && na['header'] != null) {
            final lvl = na['header'];
            blocknoteJson.add(_mkBlock('heading', extraProps: {
              'level': (lvl is int) ? lvl : (lvl as num).toInt(),
            }));
            i = j;
          } else if (newlineOp != null && na['block'] == 'ul') {
            blocknoteJson.add(_mkBlock('bulletListItem'));
            i = j;
          } else if (newlineOp != null && na['block'] == 'ol') {
            blocknoteJson.add(_mkBlock('numberedListItem'));
            i = j;
          } else if (newlineOp != null && na['blockquote'] == true) {
            blocknoteJson.add(_mkBlock('blockquote'));
            i = j;
          } else if (newlineOp != null && na['code-block'] == true) {
            blocknoteJson.add(_mkBlock('codeBlock'));
            i = j;
          } else if (newlineOp != null && na['file-block'] == true) {
            final fa = _attrs(op) ?? {};
            blocknoteJson.add({
              'id': blockId,
              'type': 'file',
              'props': {
                ...props,
                if (fa['name'] != null) 'name': fa['name'],
                if (fa['url'] != null) 'url': fa['url'],
              },
              'content': [],
              'children': [],
            });
            i = j;
          } else {
            blocknoteJson.add(_mkBlock('paragraph'));
            i = newlineOp != null ? j : j - 1;
          }
          blockIndex++;
          continue;
        }

        // 2) Ảnh
        if (v is Map && v['image'] != null) {
          final originalBlock =
              blockIndex < originalBlocks.length ? originalBlocks[blockIndex] : null;
          final blockId = (originalBlock is Map && originalBlock['id'] != null)
              ? originalBlock['id']
              : 'image_${DateTime.now().millisecondsSinceEpoch}_$blockIndex';
          final props =
              _defaultProps(originalBlock is Map ? originalBlock['props'] as Map? : null);
          props['link'] = v['image'];
          final at = _attrs(op);
          if (at != null) props['styles'] = Map<String, dynamic>.from(at);
          blocknoteJson.add({
            'id': blockId,
            'type': 'image',
            'props': props,
            'content': [],
            'children': [],
          });
          blockIndex++;

          // bỏ qua '\n' trần nếu ngay sau image
          if (i + 1 < deltaOps.length) {
            final next = deltaOps[i + 1];
            if (_isInsert(next) && _val(next) == '\n' && (_attrs(next)?.isEmpty ?? true)) {
              i++;
            }
          }
          continue;
        }

        // 3) Newline đơn (không có text trước)
        if (v is String && v == '\n') {
          final na = a;
          final originalBlock =
              blockIndex < originalBlocks.length ? originalBlocks[blockIndex] : null;
          final blockId = (originalBlock is Map && originalBlock['id'] != null)
              ? originalBlock['id']
              : 'id_${DateTime.now().millisecondsSinceEpoch}_$blockIndex';
          Map<String, dynamic> props =
              _defaultProps(originalBlock is Map ? originalBlock['props'] as Map? : null);

          final block = <String, dynamic>{
            'id': blockId,
            'type': 'paragraph',
            'props': props,
            'content': [],
            'children': [],
          };

          if (na['block'] == 'cl') {
            block['type'] = 'checkListItem';
            (block['props'] as Map)['checked'] = na['checked'] ?? false;
          } else if (na['block'] == 'ul') {
            block['type'] = 'bulletListItem';
          } else if (na['block'] == 'ol') {
            block['type'] = 'numberedListItem';
          } else if (na['header'] != null) {
            block['type'] = 'heading';
            (block['props'] as Map)['level'] =
                (na['header'] is int) ? na['header'] : (na['header'] as num).toInt();
          } else if (na['blockquote'] == true) {
            block['type'] = 'blockquote';
          } else if (na['code-block'] == true) {
            block['type'] = 'codeBlock';
          } else if (na['file-block'] == true) {
            block['type'] = 'file';
          }

          blocknoteJson.add(block);
          blockIndex++;
        }
      } catch (e) {
        // Skip invalid op and continue converting the rest
        continue;
      }
    }

    // Thêm lại table blocks (nếu có)
    if (_tableBlocks.isNotEmpty) blocknoteJson.addAll(_tableBlocks);
    return blocknoteJson;
  }
}
