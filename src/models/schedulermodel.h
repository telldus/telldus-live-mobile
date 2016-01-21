#ifndef SCHEDULERMODEL_H
#define SCHEDULERMODEL_H

#include "tlistmodel.h"

class SchedulerJob;

class SchedulerModel : public TListModel
{
	Q_OBJECT
public:
	~SchedulerModel();

	Q_INVOKABLE void addJobs(const QVariantList &jobs);
	Q_INVOKABLE SchedulerJob *findJob(int id) const;
	Q_INVOKABLE void deactivateJobs(QList<int> activeIds);
	QDateTime nextRunTimeForDevice(int deviceId) const;

	static SchedulerModel *instance();

signals:
	void jobsLoaded(const QVariantList &jobs);

public slots:
	void authorizationChanged();
private slots:
	void onJobList(const QVariantMap &result);
	void fetchDataFromCache();

private:
	explicit SchedulerModel();
	class PrivateData;
	PrivateData *d;
};

#endif // SCHEDULERMODEL_H
