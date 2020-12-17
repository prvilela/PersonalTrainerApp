class Agendamento {

  Agendamento.fromMap(Map<String,dynamic> map){
    seg = map['seg'] as bool;
    ter = map['ter'] as bool;
    quar = map['quar'] as bool;
    quin = map['quin'] as bool;
    sex = map['sex'] as bool;
    sab = map['sab'] as bool;
    dom = map['dom'] as bool;
    horarioDom = map['horarioDom'] as String;
    horarioSeg = map['horarioSeg'] as String;
    horarioTer = map['horarioTer'] as String;
    horarioQuar = map['horarioQuar'] as String;
    horarioQuin = map['horarioQuin'] as String;
    horarioSex = map['horarioSex'] as String;
    horarioSab = map['horarioSab'] as String;
  }


  Agendamento({this.dom,this.quar,this.quin,this.sab,this.seg,this.sex,this.ter,
    this.horarioDom, this.horarioSab, this.horarioSex, this.horarioQuar,
    this.horarioTer, this.horarioSeg, this.horarioQuin}){
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
  String horarioDom;
  String horarioSeg;
  String horarioTer;
  String horarioQuar;
  String horarioQuin;
  String horarioSex;
  String horarioSab;


  Agendamento clone(){
    return Agendamento(
      dom: dom,
      quar: quar,
      quin: quin,
      sab: sab,
      seg: seg,
      sex: sex,
      ter: ter,
      horarioDom: horarioDom,
      horarioSeg: horarioSeg,
      horarioTer: horarioTer,
      horarioQuar: horarioQuar,
      horarioSex: horarioSex,
      horarioSab: horarioSab,
      horarioQuin: horarioQuin,
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
      'horarioDom': horarioDom,
      'horarioSeg': horarioSeg,
      'horarioTer': horarioTer,
      'horarioQuar': horarioQuar,
      'horarioQuin': horarioQuin,
      'horarioSex': horarioSex,
      'horarioSab': horarioSab,

    };
  }


}