/*
    Уразаев Константин. ПС-22
    Вариант 8.
    Теннисный  турнир  проходит  по  олимпийской  системе  с
    выбываниями. В турнире участвуют 2^n игроков. Известен рейтинг
    каждого игрока.  Результаты турнира записаны с помощью дерева.
    Сенсацией считается выигрыш игрока с меньшим рейтингом. Выдать
    список всех сенсаций турнира с указанием номера тура,  а также
    главные сенсации, которые определяется  максимальной  разницей
    рейтингов (9).
*/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;
int maxRattingDifference = 0;
vector<string> mainSensations;

// Структура для представления игрока
struct Player {
    string name;
    int rating;
    Player(string name, int rating) : name(name), rating(rating) {}
};

// Структура для представления узла дерева
struct TreeNode {
    Player player;
    vector<TreeNode> children;
    TreeNode(Player p) : player(p) {}
};

//Получение файла с деревом
std::string GetUserInput() {
    std::string Input;
    std::cout << "Введите имя файла (0 - чтобы выйти): ";
    std::cin >> Input;
    return Input;
}

// Функция для разбора входных данных и построения дерева
TreeNode buildTree(vector<string>& lines, int& index, int dotCount) {
    if (index >= lines.size()) {
        return TreeNode(Player("", 0));  // Возвращаем пустой узел при достижении конца данных
    }

    int currentDotCount = 0;
    while (lines[index][currentDotCount] == '.') {
        currentDotCount++;
    }

    if (currentDotCount < dotCount) {
        return TreeNode(Player("", 0));  // Возвращаем пустой узел, если текущий уровень меньше ожидаемого
    }

    istringstream lineStream(lines[index].substr(currentDotCount));
    string playerName;
    int playerRating;
    lineStream >> playerName >> playerRating;

    TreeNode currentNode(Player(playerName, playerRating));
    index++;

    while (index < lines.size()) {
        TreeNode childNode = buildTree(lines, index, currentDotCount + 1);
        if (childNode.player.name.empty()) {
            break;
        }
        currentNode.children.push_back(childNode);
    }

    return currentNode;
}

// Функция для поиска сенсаций в дереве
void findSensations(const TreeNode& node, ofstream& outputFile, int parentRating, int level = 0) {
    if (node.player.rating < parentRating) {
        for (const TreeNode& child : node.children) {
            if (child.player.rating > node.player.rating) {
                outputFile << "Сенсация: " << node.player.name << " (рейтинг " << node.player.rating << ") победил " << child.player.name << " (рейтинг " << child.player.rating << ") " << endl;
                int ratingDifference = child.player.rating - node.player.rating;
                if (ratingDifference > maxRattingDifference) {

                    maxRattingDifference = ratingDifference;
                    mainSensations.clear();
                    mainSensations.push_back("Главная сенсация: " + node.player.name + " (рейтинг " + to_string(node.player.rating) + ")" + to_string(node.player.rating) + " победил игрока " + (child.player.name) + " с рейтингом " + to_string(child.player.rating));

                }
                else if (ratingDifference == maxRattingDifference) {
                    mainSensations.push_back("Главная сенсация: " + node.player.name + " (рейтинг " + to_string(node.player.rating) + ")" + to_string(node.player.rating) + " победил игрока " + (child.player.name) + " с рейтингом " + to_string(child.player.rating));
                }
            }
        }
    }

    for (const TreeNode& child : node.children) {
        findSensations(child, outputFile, max(parentRating, node.player.rating));
    }
}

void printTree(const TreeNode& node, ofstream& outputFile, int level = 0) {

    for (int i = 0; i < level; i++) {
        outputFile << "  "; 
    }
    outputFile << node.player.name << " (рейтинг " << node.player.rating << ")" << endl;

    for (const TreeNode& child : node.children) {
        printTree(child, outputFile, level + 1);
    }
}

void printTreeConsole(const TreeNode& node, int level = 0) {

    for (int i = 0; i < level; i++) {
        cout << "  ";
    }
    cout << node.player.name << " (рейтинг " << node.player.rating << ")" << endl;

    for (const TreeNode& child : node.children) {
        printTreeConsole(child, level + 1);
    }
}


int main() {
    setlocale(LC_ALL, "rus");
    string inputString = "Player_1 100\n.Player_1 100\n..Player_1 100\n...Player_1 100\n...Player_5 110\n..Player_3 80\n...Player_3 80\n...Player_6 75\n.Player_2 90\n..Player_2 90\n...Player_2 80\n...Player_7 50\n..Player_4 30\n...Player_4 30\n...Player_8 80";

    std::string InputFile;
    InputFile = GetUserInput();
    while (InputFile != "0") {
        std::ifstream input(InputFile);
        vector<string> lines;
        string line;

        // Чтение строк из входных данных и сохранение их в векторе
        while (getline(input, line)) {
            lines.push_back(line);
        }

        int index = 0;
        TreeNode root = buildTree(lines, index, 0);

        ofstream outputFile("results.txt"); // Открываем файл для записи результатов
        if (outputFile.is_open()) {

            findSensations(root, outputFile, INT_MAX);

            for (const string& sensation : mainSensations) {
                outputFile << sensation << endl;
            }

            printTree(root, outputFile);

            cout << "Введите 1, если хотите вывести дерево на экран ";
            cin >> inputString;
            cout << "\n";
            if (inputString == "1") {
                printTreeConsole(root);
            }
            

            outputFile.close(); // Закрываем файл после записи

            cout << "Результаты записаны в файл 'results.txt' \n" << endl;
            InputFile = GetUserInput();
        }
        else {
            cerr << "Ошибка открытия файла для записи" << endl;
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
