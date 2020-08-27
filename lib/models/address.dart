class Address{

  String cep;
  String rua;
  String bairro;

  Address({this.cep, this.rua, this.bairro});

  Address.fromMap(Map<String,dynamic> map){
    cep = map['cep'] as String;
    rua = map['logradouro'] as String;
    bairro = map['bairro'] as String;
  }

  @override
  String toString() {
    return 'Address{cep: $cep, rua: $rua, bairro: $bairro}';
  }
}