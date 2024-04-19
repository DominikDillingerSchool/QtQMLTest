#include "benchmark.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#if __linux__
#include <fcntl.h>
#include <iostream>
#include <unistd.h>
#endif
int main(int argc, char *argv[])
{
#if __linux__
    if (isatty(STDOUT_FILENO))
    {
        // Open /dev/tty for writing, which represents the terminal
        int tty_fd = open("/dev/tty", O_WRONLY);
        if (tty_fd != -1)
        {
            // Redirect stdout and stderr to /dev/tty
            dup2(tty_fd, STDOUT_FILENO);
            dup2(tty_fd, STDERR_FILENO);
        }
    }
#endif
    QGuiApplication app(argc, argv);

    QCoreApplication::addLibraryPath("./");

    QQmlApplicationEngine engine;

    Benchmark *benchmark = new Benchmark();
    engine.rootContext()->setContextProperty("Benchmark", benchmark);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
