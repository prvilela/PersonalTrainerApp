class StudentValidator{
  String validateName(String t){
  if(t.isEmpty) return "Preencha o nome";
  return null;
  }
  String validateBirthday(String t){
    if(t.isEmpty) return "Preencha a data de nascimento";
    return null;
  }
  String validateCpf(String t){
    if(t.isEmpty) return "Preencha o CPF";
    return null;
  }
  String validateEmail(String t){
    if(t.isEmpty) return "Preencha o E-mail";
    return null;
  }
  String validatePhone(String t){
    if(t.isEmpty) return "Preencha o Telefone";
    return null;
  }
  String validateGoal(String t){
    if(t.isEmpty) return "Preencha os Objetivos";
    return null;
  }
  String validateRestrictions(String t){
    if(t.isEmpty) return "Preencha as Restrições";
    return null;
  }
}