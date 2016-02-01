#ifndef TDQUEUE_H
#define TDQUEUE_H

#include <QQueue>
#include <QDebug>

template<typename T>
class TdQueue
{
public:
	TdQueue() {}

	void enqueue(T value) {
		enqueue(value, 100);
	}

	void enqueue(T value, int priority) {
		Item<T> item(priority,value);
		// Start at 1 so never replace the head!!
		for(int i = 1 ; i < _queue.count() ; ++i ) {
			const Item<T>& otherItem = _queue[i];
			if( priority < otherItem._priority )  {
				_queue.insert(i,item);
				qDebug().nospace().noquote() << "[QUEUE] Queue(" << _queue.count() << ") Enqueued at position " << i << " with priority " << item._priority;
				return;
			}
		}
		_queue.append(item);
		qDebug().nospace().noquote() << "[QUEUE] Queue(" << _queue.count() << ") Enqueued at the end with priority " << item._priority;
	}

	T dequeue() {
		const Item<T>& item = _queue.dequeue();
		qDebug().nospace().noquote() << "[QUEUE] Queue(" << _queue.count() << ") Dequeue with priority " << item._priority;
		return item._value;
	}

	T head() {
		const Item<T>& item = _queue.head();
		qDebug().nospace().noquote() << "[QUEUE] Queue(" << _queue.count() << ") Head with priority " << item._priority;
		return item._value;
	}

	int count() {
		return _queue.count();
	}

private:
	template<typename C>
	struct Item {
		int _priority;
		C _value;

		Item(int priority, C value) {
			_priority = priority;
			_value = value;
		}
	};

	QQueue< Item<T > > _queue;

};

#endif // TDQUEUE_H