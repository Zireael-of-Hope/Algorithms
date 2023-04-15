// ignore_for_file: non_constant_identifier_names

part of 'dart_application_1.dart';

//привести матрицу к треугольному виду (нули ниже главной диагонали)
void turnToTriangle(List<List<double>> matrix) {
  
  replaceFirstRowToBiggest(matrix);
  for (int row = 1; row < matrix.length; row++) {
    turnLowerRowToZero(matrix[0], matrix[row]);
  }
  if (matrix.length > 2) {
    List<List<double>> smaller_matrix = createSmallerMatrixInGauss(matrix);
    turnToTriangle(smaller_matrix);
    putSmallerMatrixBackInPlace(matrix, smaller_matrix);
  }
  int debug = 0;
} 

//возвращает маленькую матрицу в изначальную ниже первой строки и правее первого столбца
void putSmallerMatrixBackInPlace(List<List<double>> bigger_matrix, List<List<double>> smaller_matrix) {
  
  for (int row = 1; row < bigger_matrix.length; row++) {
    for (int column = 1; column < bigger_matrix.length + 1; column++) {
      bigger_matrix[row][column] = smaller_matrix[row - 1][column - 1];
    }
  }
  int debug = 0;
}

//создает новую матрицу, вычеркиваю первый строку и столбец
List<List<double>> createSmallerMatrixInGauss(List<List<double>> initial_matrix) {
  List<List<double>> smaller_matrix = makeMatrixDeepCopy(initial_matrix);

  smaller_matrix.removeAt(0);
  for (int row = 0; row < smaller_matrix.length; row++) {
    smaller_matrix[row].removeAt(0);
  }
  return smaller_matrix;
}

//нахождение наибольшего значения в столбце и установка его в первую строку
void replaceFirstRowToBiggest(List<List<double>> matrix_to_transform) {
  int row_max_index = 0;

  for (int row = 0; row < matrix_to_transform.length; row++) {
    if (matrix_to_transform[row][0] > matrix_to_transform[0][0]) {
      row_max_index = row;
    }
    replaceMatrixRows(matrix_to_transform, 0, row_max_index);
  }
}

//проверка нулевого столбца
bool doesMatrixHaveZeroColunm(List<List<double>> matrix_to_check) {
  int zero_column_count = 0;

  for (int column = 0; column < matrix_to_check.length; column++) {
    for (int row = 0; row < matrix_to_check.length; row++) {
      if (matrix_to_check[row][column] == 0) {
        zero_column_count++;
      }
    }
    if (zero_column_count == matrix_to_check.length) {
      return true;
    }
    zero_column_count = 0;
  }
  return false;
}

//суммирует две строки, обнуляя первый элемент второй строки
void turnLowerRowToZero(List<double> upper_row, List<double> out_lower_row) {
    double dif_ratio = out_lower_row[0] / upper_row[0];

    for (int column = 0; column < upper_row.length; column++) {
      out_lower_row[column] = out_lower_row[column] - dif_ratio * upper_row[column];
    }
    int debug = 0;
}

//поменять строки матрицы местами
void replaceMatrixRows(List<List<double>> matrix_to_transform, int row_1, int row_2) {
  List<double> temp_row = List.from(matrix_to_transform[row_1]);
  matrix_to_transform[row_1] = List.from(matrix_to_transform[row_2]);
  matrix_to_transform[row_2] = List.from(temp_row); 
}

//считает определитель матрицы
double countMatrixDet(List<List<double>> matrix_to_det) {

  switch (matrix_to_det.length) {
    case 1: {
      return matrix_to_det[0][0];
    }
    case 2: {
      return matrix_to_det[0][0] * matrix_to_det[1][1] - matrix_to_det[0][1] * matrix_to_det[1][0];
    }
    default: {
      int sign = 1;   
      double top_columns_sum = 0;
      for (int top_column = 0; top_column < matrix_to_det.length; top_column++) {
        List<List<double>> smaller_matrix_to_det = creatrSmallerMatrix(matrix_to_det, 0, top_column);
        top_columns_sum += sign * matrix_to_det[0][top_column] * countMatrixDet(smaller_matrix_to_det);
        sign *= -1;
      }
      return top_columns_sum;
    }
  }
}

//возвращает матрицу и свободные коэффициенты дополнительным столбцом из файла
Future<List<List<double>>> defineMatrixFromFile(File file_to_read) async {
  var all_data_in_file = await file_to_read.readAsLines();
  int matrix_size = int.parse(all_data_in_file[0]);
  List<List<double>> matrix_to_return = List.generate(
    matrix_size, (i) => List.generate(matrix_size, (j) => 0));

  //сама матрица
  for (int row = 1; row < matrix_size + 1; row++) {
    List<String> nums_in_row = all_data_in_file[row].split(' ');
    for (int column = 0; column < matrix_size; column++) {
      matrix_to_return[row - 1][column] = double.parse(nums_in_row[column]);
    }
  }

  //добавление свободных коэффициентов
  for (int line = matrix_size + 1; line < matrix_size * 2 + 1; line++) {
    matrix_to_return[line - matrix_size - 1].add(double.parse(all_data_in_file[line]));
  }

  return matrix_to_return;
}

//создание глубокой копии двумерного списка
List<List<T>> makeMatrixDeepCopy<T>(List<List<T>> initial_matrix) {
  List<List<T>> copy_matrix = [];

  for (List<T> sublist in initial_matrix) {
    copy_matrix.add(List.from(sublist));
  }
  return copy_matrix;
}

//отобразить систему укравнений в упрощенном виде
void printMatrixLite(List<List<double>> matrix) {
  String matrix_row = '';

  for (int row = 0; row < matrix.length; row++) {
    matrix_row = '';
    for (int column = 0; column < matrix.length; column++) {
      matrix_row += '${matrix[row][column].toStringAsFixed(2)} ';
    }
    print(matrix_row);
  }
}

//отобразить систему уравнений
void printMatrixSystem(List<List<double>> matrix) {
  String matrix_row = '';

  for (int row = 0; row < matrix.length; row++) {
    matrix_row = '';
    for (int column = 0; column < matrix.length - 1; column++) {
      matrix_row += '${matrix[row][column].toStringAsFixed(2)}*x${column + 1} + ';
    }
    matrix_row += '${matrix[row][matrix.length - 1].toStringAsFixed(2)}*x${matrix.length} = ';
    matrix_row += matrix[row][matrix.length].toStringAsFixed(2);
    print(matrix_row);
  }
}

//отобразить найденные неизвестные
void printUnknownVariables(List<double> unknown_variables, [bool isFixed = true]) {

  for (int index = 0; index < unknown_variables.length; index++) {
    if (isFixed) {
          print('x${index + 1} = ${unknown_variables[index].toStringAsFixed(2)}');
    } else { print('x$index = ${unknown_variables[index]};'); }
  }
}

//отобразить невязки
void printDiscrepancies(List<double> discrepancies) {
  for (int index = 0; index < discrepancies.length; index++) {
    print('r${index + 1} = ${discrepancies[index]}');
  }
}

//посчитать неизвестные из матрицы, преведенной к треугольному виду
List<double> countUnknownVariables(List<List<double>> matrix) {
  List<double> unknown_variables = List.filled(matrix.length, 0);
  int size = matrix.length;
  double temp_sum = 0;

  for (int row = size - 1; row > - 1; row--) {
    temp_sum = 0;
    for (int column = row + 1; column < size; column++) {
      temp_sum += matrix[row][column] * unknown_variables[column];
    }
    unknown_variables[row] = (matrix[row][size] - temp_sum) / matrix[row][row]; 
  }

  return unknown_variables;
}

//определить невязки
List<double> findDiscrepancies(List<List<double>> matrix, List<double> x_variables,List<double> out_discrenacies) {
  double left_side = 0;

  for (int row = 0; row < matrix.length; row++) {
    left_side = 0;
    for (int column = 0; column < matrix.length; column++) {
      left_side += matrix[row][column] * x_variables[column];
    }
    out_discrenacies[row] = matrix[row][matrix.length] - left_side;
  }
  return out_discrenacies;
}

//посчитать обратную матрицу
List<List<double>> createInverseMatrix(List<List<double>> matrix) {
  var copy_matrix = makeMatrixDeepCopy(matrix);
  double det = countMatrixDet(matrix);
  num sign = 1;

  for (int row = 0; row < matrix.length; row++) {
    for (int column = 0; column < matrix.length; column++) {
      sign = pow(-1, column + row);
      copy_matrix[row][column] = (1 / det) * (sign * countMatrixDet(creatrSmallerMatrix(matrix, row, column)));  
    }  
  }
  copy_matrix = transposeMatrix(copy_matrix);
  return copy_matrix;
}

//создать маленькую матрицу, убрав строку row и столбец column
List<List<double>> creatrSmallerMatrix(List<List<double>> initial_matrix, int row, int column) {
 
  if (initial_matrix.length > 2) {
    var copy_matrix = makeMatrixDeepCopy(initial_matrix);
    copy_matrix.removeAt(row);
    for (List<double> line in copy_matrix) {
      line.removeAt(column);
    }
    return copy_matrix;
  }
  else { return initial_matrix; }
}

//транспонировать матрицу
List<List<double>> transposeMatrix(List<List<double>> initial_matrix) {
  var copy_matrix = makeMatrixDeepCopy(initial_matrix);

  for (int row = 0; row < initial_matrix.length; row++) {
    for (int column = 0; column < initial_matrix.length; column++) {
      copy_matrix[row][column] = initial_matrix[column][row];
    }
  }
  return copy_matrix;
}