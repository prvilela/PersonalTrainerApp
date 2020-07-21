import 'dart:io';

import 'package:apppersonaltrainer/models/address.dart';
import 'package:dio/dio.dart';

const token = '45a5e7fc6e4ac3cfb053f2c1a2dfb6a5';

class CepAbertoService {

  Future<Address> getAddressFromCep(String cep)async{
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try{
      final response = await dio.get<Map<String,dynamic>>(endPoint);

      if(response.data.isEmpty){
        return Future.error('Cep Inválido');
      }

      final Address address = Address.fromMap(response.data);

      return address;
    }on DioError catch (e){
      return Future.error('Erro ao buscar CEP');
    }

  }

}