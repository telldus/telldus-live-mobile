#include "Push.h"
#include "config.h"

#include <QDebug>

class Push::PrivateData {
public:
};

Push::Push()
	:AbstractPush()
{
	d = new PrivateData;
	registerForPush();
}

Push::~Push() {
}
