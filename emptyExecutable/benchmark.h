#pragma once

#include <QObject>

class Benchmark : public QObject
{
    Q_OBJECT

  public:
    static Q_INVOKABLE void getCurrentMemoryUsage();
};