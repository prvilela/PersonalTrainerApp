class Agendamento {

  Agendamento.fromMap(Map<String,dynamic> map){
    seg = map['seg'] as bool;
    ter = map['ter'] as bool;
    quar = map['quar'] as bool;
    quin = map['quin'] as bool;
    sex = map['sex'] as bool;
    sab = map['sab'] as bool;
    dom = map['dom'] as bool;
    horario = map['horario'] as String;
  }


  Agendamento({this.dom,this.quar,this.quin,this.sab,this.seg,this.sex,this.ter,
    this.horario}){
    this.dom = this.dom != null ? this.dom : false;
    this.seg = this.seg != null ? this.seg : false;
    this.ter = this.ter != null ? this.ter : false;
    this.quar = this.quar != null ? this.quar : false;
    this.quin = this.quin != null ? this.quin : false;
    this.sex = this.sex != null ? this.sex : false;
    this.sab = this.sab != null ? this.sab : false;
  }

  bool seg;
  bool ter;
  bool quar;
  bool quin;
  bool sex;
  bool sab;
  bool dom;
  String horario;

  Agendamento clone(){
    return Agendamento(
      dom: dom,
      quar: quar,
      quin: quin,
      sab: sab,
      seg: seg,
      sex: sex,
      ter: ter,
      horario: horario
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'dom': dom,
      'quar': quar,
      'quin': quin,
      'sab': sab,
      'seg': seg,
      'sex': sex,
      'ter': ter,
      'horario': horario
    };
  }

  @override
  String toString() {
    return 'Agendamento{seg: $seg, ter: $ter, quar: $quar, quin: $quin, sex: $sex, sab: $sab, dom: $dom, horario: $horario}';
  }
}