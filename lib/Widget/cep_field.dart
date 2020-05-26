import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:personal_trainer/blocs/cep_bloc.dart';
import 'package:personal_trainer/model/address.dart';

class CepField extends StatefulWidget {

  CepField({this.decoration, this.onSaved, this.initial});
  final InputDecoration decoration;
  final FormFieldSetter<Address> onSaved;
  final String initial;

  @override
  _CepFieldState createState() => _CepFieldState();
}

class _CepFieldState extends State<CepField> {

  InputDecoration get decoration => widget.decoration;
  FormFieldSetter<Address> get onSaved => widget.onSaved;
  String get initial => widget.initial;

  CepBloc cepBloc;

  @override
  void initState() {
    super.initState();
    cepBloc = CepBloc();
  }


  @override
  void dispose() {
    cepBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CepBlocState>(
        initialData: CepBlocState(
            cepFieldState: CepFieldState.INITIALIZING
        ),
        stream: cepBloc.outCep,
        builder: (context, snapshot) {
          if(snapshot.data.cepFieldState == CepFieldState.INITIALIZING)
            return Container();
          return Column(
            children: [
              TextFormField(
                initialValue: initial,
                decoration: decoration,
                style: TextStyle(color: Colors.orange[700], fontSize: 18),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  CepInputFormatter(),
                ],
                onSaved: (c){
                  onSaved(snapshot.data.address);
                },
                onChanged: cepBloc.onChanged,
                validator: (c){
                  switch(snapshot.data.cepFieldState){
                    case CepFieldState.INITIALIZING:
                    case CepFieldState.INCOMPLETE:
                    case CepFieldState.INVALID:
                      return 'Campo obrigatorio';
                    case CepFieldState.VALID:
                  }
                  return null;
                },
              ),
              buildInformation(snapshot.data)
            ],
          );
        }
    );
  }

  Widget buildInformation(CepBlocState blocState){
    switch(blocState.cepFieldState){
      case CepFieldState.INITIALIZING:
      case CepFieldState.INCOMPLETE:
        return Container();
      case CepFieldState.INVALID:
        return Container(
          height: 50,
          padding: const EdgeInsets.all(8),
          color: Colors.red.withAlpha(100),
          alignment: Alignment.center,
          child: Text(
            'Cep Inválido',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
          ),
        );
      case CepFieldState.VALID:
        final _address = blocState.address;
        return Container(
          height: 50,
          padding: const EdgeInsets.all(8),
          color: Colors.pink,
          alignment: Alignment.center,
          child: Text(
            'Localização: ${_address.district} - ${_address.city} - ${_address.federativeUnit}',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        );
    }
  }

}
