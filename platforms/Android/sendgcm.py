from pygcm.manage import GCMManager
import time
m = GCMManager('AIzaSyAg2Deu5iC2T0VBVFuB2W741BOPwHbYcZQ')
ids = ['fXGH8mWlI1k:APA91bEarPW6-_Em5MkfHleZ_Ifo8tuWJcnHnvwQoUFaT6P4_y_lqgmNZx0F2QXn-qSq1CbXCv7Xu0Sf0CPnQKSZcbkILzVIrL6f421qTXlbSruHHslYpZm2mvRaPiw0KGzUVYsAhcIp']
print m.send(ids, "Time: " + time.ctime())