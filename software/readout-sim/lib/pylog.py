import logging
import sys

c_HEADER = '\033[95m'
c_OKBLUE = '\033[94m'
c_OKGREEN = '\033[92m'
c_WARNING = '\033[93m'
c_FAIL = '\033[91m'
c_ENDC = '\033[0m'
c_BOLD = '\033[1m'
c_UNDERLINE = '\033[4m'

class MyFilter(object):
    def __init__(self, level):
        self.__level = level

    def filter(self, logRecord):
        # return logRecord.levelno == self.__level
        return logRecord.levelno == logging.INFO or logRecord.levelno == logging.DEBUG


log = logging.getLogger()
log.setLevel(logging.DEBUG)

fmt = logging.Formatter("[%(levelname)s] %(message)s")
sh = logging.StreamHandler(sys.stdout)
sh.addFilter(MyFilter(logging.INFO))
sh.setFormatter(fmt)
log.addHandler(sh)

# fmt = logging.Formatter("[%(levelname)s] %(message)s")
# sh = logging.FileHandler('logs/testbench.log')
# sh.addFilter(MyFilter(logging.INFO))
# sh.setFormatter(fmt)
# log.addHandler(sh)

# fmt = logging.Formatter("[%(levelname)s] %(message)s")
# sh = logging.StreamHandler(sys.stdout)
# sh.setLevel(logging.WARNING)
# sh.setFormatter(fmt)
# log.addHandler(sh)

# fmt = logging.Formatter("[%(levelname)s] %(message)s")
# sh = logging.FileHandler('logs/testbench_err.log')
# sh.setLevel(logging.WARNING)
# sh.setFormatter(fmt)
# log.addHandler(sh)


# class MyFilter(object):
#     def __init__(self, level):
#         self.__level = level
#
#     def filter(self, logRecord):
#         return logRecord.levelno <= self.__level


# handler1.addFilter(MyFilter(logging.INFO))
# ...
# handler2.addFilter(MyFilter(logging.ERROR))
# import logging
#
# mylogger = logging.getLogger('mylogger')
# handler1 = logging.FileHandler('usr.log')
# handler1.setLevel(logging.INFO)
# mylogger.addHandler(handler1)
# handler2 = logging.FileHandler('dev.log')
# handler2.setLevel(logging.ERROR)
# mylogger.addHandler(handler2)
# mylogger.setLevel(logging.INFO)
#
# mylogger.critical('A critical message')
# mylogger.info('An info message')



# log = logging.getLogger()
# # This is a global level, sets the miminum level which can be reported
# log.setLevel(logging.DEBUG)
# sh = logging.StreamHandler(sys.stderr)
# sh.setLevel(logging.INFO)
# log.addHandler(sh)
# fh = logging.FileHandler(sys.argv[0].replace('py', 'log'), 'w')
# fh.setLevel(logging.DEBUG)
# fmt = logging.Formatter('[%(levelname)s] %(message)s')
# fh.setFormatter(fmt)
# log.addHandler(fh)


# fh = logging.FileHandler('../logs/create_test_series.log', 'w')
# fh.setLevel(logging.DEBUG)
# log = logging.getLogger()
#
#
#
# logging.basicConfig(format = u'%(levelname)-8s [%(asctime)s] %(message)s', level = logging.DEBUG, filename = u'../logs/create_test_series.log')

# fmt = logging.Formatter('[%(levelname)s] %(message)s')
# fmt = logging.Formatter(u'%(filename)s[LINE:%(lineno)d]# %(levelname)-8s [%(asctime)s]  %(message)s')
# fh.setFormatter(fmt)
# log.addHandler(fh)

# to do:
# check data time delta
# redo split function
