#include "benchmark.h"
#include "listModel.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <string>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::addLibraryPath("./");

    QQmlApplicationEngine engine;

    ListModel *model = new ListModel();
    engine.rootContext()->setContextProperty("CustomListModel", model);

    Benchmark *benchmark = new Benchmark();
    engine.rootContext()->setContextProperty("Benchmark", benchmark);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
