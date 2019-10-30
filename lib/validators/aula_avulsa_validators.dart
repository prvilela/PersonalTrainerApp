class AulaAvulsaValidator{
  String validateName(String t){
  if(t.isEmpty) return "Preencha o Nome";
  return null;
  }
  String validateCpf(String t){
    if(t.isEmpty) return "Preencha o CPF";
    return null;
  }
   String validateDate(String t){
    if(t.isEmpty) return "Preencha a Data";
    return null;
  }
   String validateHour(String t){
    if(t.isEmpty) return "Preencha o Horário";
    return null;
  }
  String validateGym(String t){
    if(t.isEmpty) return "Preencha a Academia";
    return null;
  }
  String validateDuration(String t){
    if(t.isEmpty) return "Preencha a Duração";
    return null;
  }
  String validatePrice(String t){
    if(t.isEmpty) return "Preencha o Preço";
    return null;
  }
  String validateFrequency(String t){
    if(t.isEmpty) return "Preencha a Frequência";
    return null;
  }
}