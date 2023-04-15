// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';
part 'functions.dart';

void main() async {

  File file = File('D:\\Dart Projects\\dart_application_1\\lib\\test.txt');

  var matrix = await defineMatrixFromFile(file);
  List<double> x_variables = List.filled(matrix.length, 0);
  List<double> discrepancies = List.filled(matrix.length, 0);

  var inverse_matrix = makeMatrixDeepCopy(matrix);
  printMatrixSystem(matrix);

  if (countMatrixDet(matrix) != 0 && doesMatrixHaveZeroColunm(matrix) != true) {
    print('\nМатрица невырожденная, определитель матрицы = ${countMatrixDet(matrix)}');
    print('Матрица не имеет нулевых колонок\n');

    turnToTriangle(matrix);
    x_variables = countUnknownVariables(matrix);

    printMatrixSystem(matrix);
    print('');

    printUnknownVariables(x_variables);   

    print('\nНевязки:');
    countDiscrepancies(matrix, x_variables, discrepancies);
    printDiscrepancies(discrepancies); 

    print('\nОбратная матрица:');
    inverse_matrix = createInverseMatrix(inverse_matrix);
    printMatrixLite(inverse_matrix);

    writeResults(file, inverse_matrix, x_variables, discrepancies);
  } else {
    print('\nМатрица вырожденная или имеет нулевые колонки');
  }
}



