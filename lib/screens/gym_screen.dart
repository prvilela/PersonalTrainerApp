import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_trainer/blocs/gym_bloc.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/range_slider/flutter_range_slider.dart' as frs;


class GymScreen extends StatefulWidget {
  final DocumentSnapshot gym;
  GymScreen({this.gym});
  @override
  _GymScreenState createState() => _GymScreenState(gym);
  static pegarId() {}
}

class _GymScreenState extends State<GymScreen> {
  final GymBloc _gymBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _GymScreenState(DocumentSnapshot gym):
    _gymBloc = GymBloc(gym);

  //valores de cada range slider
  List<RangeSliderData> rangeSliders;
  double _lowerValue = 0;
  double _upperValue = 24;
  double _lowerValue1 = 0;
  double _upperValue1 = 24;
  double _lowerValue2 = 0;
  double _upperValue2 = 24;

  @override
  void initState() {
    super.initState();
    rangeSliders = _rangeSliderDefinitions();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoratiom(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    InputDecoration _buildDecorationName(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder<bool>(
          stream: _gymBloc.outCreated,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Academia":"Cadastrar Academia");
          }
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: <Widget>[
         StreamBuilder<bool>(
            stream: _gymBloc.outCreated,
            initialData: false,
            builder: (context,snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                  stream: _gymBloc.outLoading,
                  initialData: false,
                  builder: (context, snapshot) {
                    return IconButton(icon: Icon(Icons.remove),
                      onPressed: snapshot.data ? null : (){
                        _gymBloc.deleteGym();
                        Navigator.of(context).pop();
                      },
                    );
                  }
                );
              else return Container();
            },
          ),

          StreamBuilder<bool>(
            stream: _gymBloc.outLoading,
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
                onPressed: saveGym,
              );
            }
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
          stream: _gymBloc.outData,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();
            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  style: _fieldStale,
                  initialValue: snapshot.data["name"],
                  decoration: _buildDecorationName("Nome"),
                  onSaved: _gymBloc.saveName,
                ),
                SizedBox(height: 8.0), //Adicionar espaçamento entre os TextFields                            

                TextFormField(
                  style: _fieldStale,
                  initialValue: snapshot.data["location"],
                  decoration: _buildDecoratiom("Endereço"),
                  onSaved: _gymBloc.saveLocation,
                ),
                SizedBox(height: 8.0),

                TextFormField(
                  style: _fieldStale,
                  initialValue: snapshot.data["phone"],
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(digito_9: true),
                  ],
                  decoration: _buildDecoratiom("Telefone"),
                  onSaved: _gymBloc.savePhone,
                ),
                SizedBox(height: 8.0),

                TextFormField(
                  style: _fieldStale,
                  initialValue: snapshot.data["preco"],
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters:[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration: _buildDecoratiom("Preço"),
                  onSaved: _gymBloc.savePreco,
                ),
                SizedBox(height: 14.0),

                Text("Semana: " + snapshot.data["horarioSemanaA"].toString()+ " - " + snapshot.data["horarioSemanaF"].toString(),
                style: _fieldStale),
                frs.RangeSlider(
                  min: 0,
                  max: 24,          
                  lowerValue: _lowerValue,
                  upperValue: _upperValue,
                  divisions: 24,
                  showValueIndicator: true,
                  valueIndicatorMaxDecimals: 0,
                  onChanged: (double newLowerValue, double newUpperValue) {
                    setState(() {
                      _lowerValue = newLowerValue;
                      _upperValue = newUpperValue;
                    });
                    
                    if(_lowerValue.toString() == "null"){
                      _lowerValue = 0.0;
                    }
                    if(_upperValue.toString() == "null"){
                      _upperValue = 0.0;
                    }
                    _gymBloc.saveHorarioSemanaA(_lowerValue.toString());
                    _gymBloc.saveHorarioSemanaF(_upperValue.toString());
                  },
                ),
                SizedBox(height: 8.0),

                Text("Sábado: " + snapshot.data["horarioSabadoA"].toString()+ " - " + snapshot.data["horarioSabadoF"].toString() , style: _fieldStale),
                frs.RangeSlider(
                  min: 0,
                  max: 24,
                  lowerValue: _lowerValue1,
                  upperValue: _upperValue1,
                  divisions: 24,
                  showValueIndicator: true,
                  valueIndicatorMaxDecimals: 0,
                  onChanged: (double newLowerValue, double newUpperValue) {
                    setState(() {
                      _lowerValue1 = newLowerValue;
                      _upperValue1 = newUpperValue;
                    });
                    _gymBloc.saveHorarioSabadoA(_lowerValue1.toString());
                    _gymBloc.saveHorarioSabadoF(_upperValue1.toString());
                  },
                ),
                SizedBox(height: 8.0),

                Text("Domingo: " + snapshot.data["horarioDomingoA"].toString()+" - "+ snapshot.data["horarioDomingoF"].toString() , style: _fieldStale),
                frs.RangeSlider(
                  min: 0,
                  max: 24,
                  lowerValue: _lowerValue2,
                  upperValue: _upperValue2,
                  divisions: 24,
                  showValueIndicator: true,
                  valueIndicatorMaxDecimals: 0,
                  onChanged: (double newLowerValue, double newUpperValue) {
                    setState(() {
                      _lowerValue2 = newLowerValue;
                      _upperValue2 = newUpperValue;
                    });
                    _gymBloc.saveHorarioDomingoA(_lowerValue2.toString());
                    _gymBloc.saveHorarioDomingoF(_upperValue2.toString());
                  },
                ),      
                  
                FutureBuilder(
                  future: FirebaseAuth.instance.currentUser(),
                    builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                      if (snapshot.hasData) {
                        _gymBloc.saveId(snapshot.data.uid);
                        return Text("");
                      }
                      return Text("");
                    } 
                  )

                ],
              );
            }
          )
      ),
    );

  }

  void saveGym() async{
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Salvando academia...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.black,
      )
    );

    bool success = await _gymBloc.saveGym();
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(success ? "Academia salva":"Erro ao salvar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      )
    );
    }
  }


//DAQUI PRA BAIXO APENAS CONFIG DOS RANGE SLIDERS
  List<Widget> _buildRangeSliders() {
    List<Widget> children = <Widget>[];
    for (int index = 0; index < rangeSliders.length; index++) {
      children
          .add(rangeSliders[index].build(context, (double lower, double upper) {
        // adapt the RangeSlider lowerValue and upperValue
        setState(() {
          rangeSliders[index].lowerValue = lower;
          rangeSliders[index].upperValue = upper;
        });
      }));
      // Add an extra padding at the bottom of each RangeSlider
      children.add(SizedBox(height: 8.0));
    }

    return children;
  }

  // -------------------------------------------------
  // Creates a list of RangeSlider definitions
  // -------------------------------------------------
  List<RangeSliderData> _rangeSliderDefinitions() {
    return <RangeSliderData>[
      RangeSliderData(
          min: 0, max: 100, lowerValue: 10, upperValue: 100),
      RangeSliderData(
          min: 0,
          max: 100,
          lowerValue: 25,
          upperValue: 75,
          divisions: 20,
          overlayColor: Colors.red[100]),
      RangeSliderData(
          min: 0,
          max: 100,
          lowerValue: 10,
          upperValue: 30,
          showValueIndicator: false,
          valueIndicatorMaxDecimals: 0),
      RangeSliderData(
          min: 0,
          max: 100,
          lowerValue: 10,
          upperValue: 30,
          showValueIndicator: true,
          valueIndicatorMaxDecimals: 0,
          activeTrackColor: Colors.red,
          inactiveTrackColor: Colors.red[50],
          valueIndicatorColor: Colors.green),
      RangeSliderData(
          min: 0,
          max: 100,
          lowerValue: 25,
          upperValue: 75,
          divisions: 20,
          thumbColor: Colors.grey,
          valueIndicatorColor: Colors.grey),
    ];
  }

}

class RangeSliderData {
  double min;
  double max;
  double lowerValue;
  double upperValue;
  int divisions;
  bool showValueIndicator;
  int valueIndicatorMaxDecimals;
  bool forceValueIndicator;
  Color overlayColor;
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color thumbColor;
  Color valueIndicatorColor;
  Color activeTickMarkColor;

  static const Color defaultActiveTrackColor = const Color(0xFFeb8934);
  static const Color defaultInactiveTrackColor = const Color(0xFFeb9f34);
  static const Color defaultActiveTickMarkColor = const Color(0xFFeb8934);
  static const Color defaultThumbColor = const Color(0xFFeb8934);
  static const Color defaultValueIndicatorColor = const Color(0xFFeb9f34);
  static const Color defaultOverlayColor = const Color(0x29eb9f34);

  RangeSliderData({
    this.min,
    this.max,
    this.lowerValue,
    this.upperValue,
    this.divisions,
    this.showValueIndicator: true,
    this.valueIndicatorMaxDecimals: 1,
    this.forceValueIndicator: false,
    this.overlayColor: defaultOverlayColor,
    this.activeTrackColor: defaultActiveTrackColor,
    this.inactiveTrackColor: defaultInactiveTrackColor,
    this.thumbColor: defaultThumbColor,
    this.valueIndicatorColor: defaultValueIndicatorColor,
    this.activeTickMarkColor: defaultActiveTickMarkColor,
  });

  // Returns the values in text format, with the number
  // of decimals, limited to the valueIndicatedMaxDecimals
  //
  String get lowerValueText =>
      lowerValue.toStringAsFixed(valueIndicatorMaxDecimals);
  String get upperValueText =>
      upperValue.toStringAsFixed(valueIndicatorMaxDecimals);

  // Builds a RangeSlider and customizes the theme
  // based on parameters
  //
  Widget build(BuildContext context, frs.RangeSliderCallback callback) {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              minWidth: 40.0,
              maxWidth: 40.0,
            ),
            child: Text(lowerValueText),
          ),
          Expanded(
            child: SliderTheme(
              // Customization of the SliderTheme
              // based on individual definitions
              // (see rangeSliders in _RangeSliderSampleState)
              data: SliderTheme.of(context).copyWith(
                overlayColor: overlayColor,
                activeTickMarkColor: activeTickMarkColor,
                activeTrackColor: activeTrackColor,
                inactiveTrackColor: inactiveTrackColor,
                //trackHeight: 8.0,
                thumbColor: thumbColor,
                valueIndicatorColor: valueIndicatorColor,
                showValueIndicator: showValueIndicator
                    ? ShowValueIndicator.always
                    : ShowValueIndicator.onlyForDiscrete,
              ),
              child: frs.RangeSlider(
                min: min,
                max: max,
                lowerValue: lowerValue,
                upperValue: upperValue,
                divisions: divisions,
                showValueIndicator: showValueIndicator,
                valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                onChanged: (double lower, double upper) {
                  // call
                  callback(lower, upper);
                },
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minWidth: 40.0,
              maxWidth: 40.0,
            ),
            child: Text(upperValueText),
          ),
        ],
      ),
    );
  }
}


