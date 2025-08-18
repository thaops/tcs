// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class WigetRow extends StatefulWidget {
  final String? name;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool? isPhone;
  final Color? color; 
  const WigetRow({
    Key? key,
    this.name,
    this.icon,
    this.onTap,
    this.isPhone =  false,
    this.color
  }) : super(key: key);

  @override
  State<WigetRow> createState() => _WigetRowState();
}

class _WigetRowState extends State<WigetRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,

      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(widget.icon ?? Icons.person, color: widget.color ?? Colors.black,),
              SizedBox(
                width: 20,
              ),
              Expanded(child: TextWidget(text:  widget.name ?? 'Nhân Viên',maxLines: 3, fontSize: 14,fontWeight: FontWeight.w500 ,color: widget.color ?? Colors.black,)),
            widget.isPhone == true ?  Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.phone,
                  size: 16,
                  color:widget.color ?? Colors.white,
                ),
              )
              : Container(width: 0,)
            ],
          ),
        ),
      ),
    );
  }
}
