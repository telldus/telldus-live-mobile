#ifndef PUSH_H
#define PUSH_H

#include "AbstractPush.h"

class Push : public AbstractPush {
	Q_OBJECT
	friend class AbstractPush;
public:
	virtual ~Push();

protected:
	explicit Push();

private:
	class PrivateData;
	PrivateData *d;
};

#endif // PUSH_H
