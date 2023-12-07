/*
    Уразаев Константин, ПС-22
    Вариант 16. 
    Реализовать алгоритм поиска кратчайших путей  Флойда  и
    проиллюстрировать по шагам этапы его выполнения (9).
*/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <conio.h>

using namespace std;

const int INF = 1e9;

std::string GetUserInput() {
    std::string Input;
    std::cout << "Введите имя файла (0 для завершения программы): ";
    std::cin >> Input;
    return Input;
}

void printMatrix(const vector<vector<int>>& matrix) {
    int n = matrix.size();
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            if (matrix[i][j] == INF) {
                cout << "INF\t";
            }
            else {
                cout << matrix[i][j] << "\t";
            }
        }
        cout << endl;
    }
    _getch();
}

void floydWarshall(vector<vector<int>>& graph) {

    int n = graph.size();

    // Шаги алгоритма
    for (int k = 0; k < n; ++k) {
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (graph[i][k] != INF && graph[k][j] != INF
                    && graph[i][k] + graph[k][j] < graph[i][j]) {
                    graph[i][j] = graph[i][k] + graph[k][j];
                }
            }
        }

        cout << "Шаг " << k + 1 << ":" << endl;
        printMatrix(graph);
        cout << endl;
        _getch();
    }
}

int main() {
    setlocale(LC_ALL, "rus");

    std::string InputFile;
    InputFile = GetUserInput();
    
    while (InputFile != "0") {

        std::ifstream FIn(InputFile);
        if (FIn.is_open()) {

            int n, m;
            FIn >> n >> m;

            vector<vector<int>> graph(n, vector<int>(n, INF));

            for (int i = 0; i < m; ++i) {
                int u, v, w;
                FIn >> u >> v >> w;
                graph[u - 1][v - 1] = w;
            }

            FIn.close();

            cout << "Матрица расстояний: " << endl;
            printMatrix(graph);
            cout << endl;

            floydWarshall(graph);

            InputFile = GetUserInput();

        } else {
            std::cout << "Файл с вершинами не существует\n";
            InputFile = GetUserInput();
        }
    }
    return 0;
}




// Запуск программы: CTRL+F5 или меню "Отладка" > "Запуск без отладки"
// Отладка программы: F5 или меню "Отладка" > "Запустить отладку"

// Советы по началу работы 
//   1. В окне обозревателя решений можно добавлять файлы и управлять ими.
//   2. В окне Team Explorer можно подключиться к системе управления версиями.
//   3. В окне "Выходные данные" можно просматривать выходные данные сборки и другие сообщения.
//   4. В окне "Список ошибок" можно просматривать ошибки.
//   5. Последовательно выберите пункты меню "Проект" > "Добавить новый элемент", чтобы создать файлы кода, или "Проект" > "Добавить существующий элемент", чтобы добавить в проект существующие файлы кода.
//   6. Чтобы снова открыть этот проект позже, выберите пункты меню "Файл" > "Открыть" > "Проект" и выберите SLN-файл.
