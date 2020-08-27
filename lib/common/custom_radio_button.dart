import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {

  const CustomRadioButton({this.value,this.gender,this.onTap});

  final String gender;
  final String value;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    bool diff = gender == value;
    Color color;
    if(diff){
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
