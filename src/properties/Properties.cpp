#include "Properties.h"
#include "properties/PropertiesTheme.h"

class Properties::PrivateData {
public:
	static Properties *instance;
	QString foo;
	PropertiesTheme *theme;
};

Properties *Properties::PrivateData::instance = 0;

Properties::Properties(QObject *parent):QObject(parent) {
	d = new PrivateData;
	d->foo = "bar";
	d->theme = new PropertiesTheme(this);
}

Properties::~Properties() {
	delete d;
}

Properties *Properties::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new Properties();
	}
	return PrivateData::instance;
}

PropertiesTheme *Properties::theme() const {
	return d->theme;
}

QString Properties::foo() const {
	return d->foo;
}

void Properties::setFoo(const QString &foo) {
	d->foo = foo;
	emit fooChanged(foo);
}
