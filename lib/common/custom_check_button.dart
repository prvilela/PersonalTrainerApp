import 'package:flutter/material.dart';

class CustomCheckButton extends StatelessWidget {

  const CustomCheckButton({this.value,this.onTap,this.isChecked});

  final bool isChecked;
  final String value;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    Color color;
    if(isChecked != null && isChecked){
      color = Theme.of(context).primaryColor;
    }else{
      color = Colors.grey;
    }
    return GestureDetector(
      onTap: (){
        onTap(value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                  color: color,
                  width: 2
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 15
              ),
            ),
          ),
        ],
      ),
    );
  }
}
