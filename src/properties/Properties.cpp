#include "Properties.h"
#include "properties/PropertiesTheme.h"
#include "properties/PropertiesUi.h"

class Properties::PrivateData {
public:
	static Properties *instance;
	QString foo;
	PropertiesTheme *theme;
	PropertiesUi *ui;
};

Properties *Properties::PrivateData::instance = 0;

Properties::Properties(QObject *parent):QObject(parent) {
	d = new PrivateData;
	d->foo = "bar";
	d->theme = new PropertiesTheme(this);
	d->ui = new PropertiesUi(this);
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

PropertiesUi *Properties::ui() const {
	return d->ui;
}

QString Properties::foo() const {
	return d->foo;
}

void Properties::setFoo(const QString &foo) {
	d->foo = foo;
	emit fooChanged(foo);
}
