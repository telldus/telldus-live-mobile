var db;

function setupCache(schedulerModel, database) {
	db = database;
	schedulerModel.rowsInserted.connect(function(index, start, end) {
		var jobs = [];
		for(var i = start; i <= end; ++i) {
			var job = schedulerModel.get(i);
			jobs.push(job);
			job.typeChanged.connect(job, function() { save([this]) });
//			job.stateValueChanged.connect(job, function() { save([this]) });
		}
		//Save them to the cache
		save(jobs);
	});
	schedulerModel.jobsLoaded.connect(function(jobs) {
		db.transaction(function(tx) {
			var ids = [];
			for (var i = 0; i < schedulerModel.length; ++i) {
				//See if the job is in the one got from the server
				var found = false;
				for (var j in jobs) {
					if (jobs[j].id == schedulerModel.get(i).id) {
						found = true;
						break;
					}
				}
				if (found) {
					continue;
				}
				ids.push(schedulerModel.get(i).id);
				tx.executeSql('DELETE FROM Scheduler WHERE id = ?', [schedulerModel.get(i).id]);
			}
			for(var i in ids) {
				for (var j = 0; j < schedulerModel.length; ++j) {
					if (schedulerModel.get(j).id == ids[i]) {
						schedulerModel.splice(j, 1);
						break;
					}
				}
			}
		});
	});

	db.transaction(function(tx) {
		var rs = tx.executeSql('SELECT id, deviceId, method, methodValue, nextRunTime, type, hour, minute, offset, randomInterval, retries, retryInterval, weekdays FROM Scheduler ORDER BY id');
		var jobList = [];
		for(var i = 0; i < rs.rows.length; ++i) {
			jobList.push({
				'id': rs.rows.item(i).id,
				'deviceId': parseInt(rs.rows.item(i).deviceId, 10),
				'method': parseInt(rs.rows.item(i).method, 10),
				'methodValue': rs.rows.item(i).methodValue,
				'nextRunTime': parseInt(rs.rows.item(i).nextRunTime, 10),
				'type': parseInt(rs.rows.item(i).type, 10),
				'hour': parseInt(rs.rows.item(i).hour, 10),
				'minute': parseInt(rs.rows.item(i).minute, 10),
				'offset': parseInt(rs.rows.item(i).offset, 10),
				'randomInterval': parseInt(rs.rows.item(i).randomInterval, 10),
				'retries': parseInt(rs.rows.item(i).retries, 10),
				'retryInterval': parseInt(rs.rows.item(i).retryInterval, 10),
				'weekdays': rs.rows.item(i).weekdays
			});
		}

		schedulerModel.addJobs(jobList);
	});
}

function save(jobs) {
	db.transaction(function(tx) {
		for(var i = 0; i < jobs.length; ++i) {
			tx.executeSql('REPLACE INTO Scheduler (id, deviceId, method, methodValue, nextRunTime, type, hour, minute, offset, randomInterval, retries, retryInterval, weekdays) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
				[jobs[i].id, jobs[i].deviceId, jobs[i].method, jobs[i].methodValue, jobs[i].nextRunTime, jobs[i].type, jobs[i].hour, jobs[i].minute, jobs[i].offset, jobs[i].randomInterval, jobs[i].retries, jobs[i].retryInterval, jobs[i].weekdays]
			);
		}
	});
}

