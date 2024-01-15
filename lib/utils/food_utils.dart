bool containsNoAllergens(List<String> labels, Map<String, dynamic> allergies) {
  for (String label in labels) {
    if (allergies.containsKey(label) && allergies[label] == 'NO') {
      return true;
    }
  }
  return false;
}

bool containsWarnAllergens(
    List<String> labels, Map<String, dynamic> allergies) {
  for (String label in labels) {
    if (allergies.containsKey(label) && allergies[label] == 'WARN') {
      return true;
    }
  }
  return false;
}