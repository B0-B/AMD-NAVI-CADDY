#!/usr/bin/env python3

# ---- parameters ----
worker_name = "rig"
miner_path = "~/miner/teamredminer-v0.10.5.1-linux"
period_in_minutes = 5
wallets = {
    "EthereumPoW": "0x4bF616b37fFD9bFEe3323D2a1B162732B8499FDE",
    "EthereumClassic": None,
    "Ergo": None,
    "Vertcoin": None,
    "Ravencoin": None,
    "Grin-CT32": None,
    "Ubiq": None,
    "Kaspa": None,
    "Firo": None
}
# --------------------


from os import path, system, kill
from requests import get
from time import sleep
from multiprocessing import Process
from signal import SIGTERM
from datetime import datetime
from traceback import format_exc
import psutil


class watchdog:

    '''
    A simple watchdog which repeatedly evaluates the most profitable PoW algorithm for teamredminer
    via whattomine.com json rest-API and (re-)starts automatic threads with the newly picked algorithm. 
    '''

    def __init__(self,  wallets, miner_path) -> None:

        self.path = path.dirname(path.realpath(__file__))
        self.miner_path = miner_path
        self.name = None
        self.pid = None
        self.algo = None
        self.start_cmd = None
        self.stats = None
        self.wallets = wallets
        self.workload = None

        self.data = {
            "EthereumPoW": {
                "a": "ethash",
                "u": "stratum+tcp://ethw.2miners.com:2020",
                "p": "--eth_config=B",
            },
            "EthereumClassic": {
                "a": "etchash",
                "u": "stratum+tcp://eu1-etc.ethermine.org:4444",
                "p": "",
            },
            "Ergo": {
                "a": "autolykos2",
                "u": "stratum+tcp://pool.eu.woolypooly.com:3100",
                "p": "",
            },
            "Vertcoin": {
                "a": "verthash",
                "u": "stratum+tcp://vtc.suprnova.cc:1777",
                "p": "",
            },
            "Ravencoin": {
                "a": "kawpow",
                "u": "stratum+tcp://stratum-ravencoin.flypool.org:3333",
                "p": "",
            },
            "Grin-CT32": {
                "a": "cuckatoo31_grin",
                "u": "stratum+tcp://grin.2miners.com:3030",
                "p": "",
            },
            "Ubiq": {
                "a": "Ubqhash",
                "u": "stratum+tcp://eu.crazypool.org:3335",
                "p": "",
            },
            "Kaspa": {
                "a": "kas",
                "u": "stratum+tcp://pool.woolypooly.com:3112",
                "p": "",
            },
            "Firo": {
                "a": "firopow",
                "u": "stratum+tcp://firo.2miners.com:8181",
                "p": "",
            }
        }

    def build_start_command (self):

        '''
        Creates optimal starting command.
        '''

        al = self.data[self.algo]
        if (self.miner_path[-1] != '/'):
            self.miner_path += '/'
        command = f'{self.miner_path}teamredminer -a {al["a"]} -o {al["u"]} -u {worker_name}.{self.wallets[self.algo]} {al["p"]}'
        self.start_cmd = command
        return self.start_cmd
    
    def crawl_whattomine (self):

        '''
        Returns current mining statistics of all algos in one json object.
        Overrides the stats variable.
        '''
        
        self.stats = get('https://whattomine.com/coins.json').json()['coins']
        return self.stats

    def log (self, *out, col=""):
        if col == 'r':
            col = '\033[91m'
        elif col == 'b':
            col = '\033[96m'
        elif col == 'g':
            col = '\033[92m'
        elif col == 'y':
            col = '\033[93m'
        else:
            col = ''
        print(f'{col}[{datetime.now().utcnow()}]\t'+'\t'.join(out)+'\033[0m')

    def select_most_profitable_algo (self):
        
        '''
        Selects the most profitable algorithm (for which a wallet is declared)
        from crawl_whattomine return called in advance.
        '''

        if self.stats:
            for algo in self.stats:
                if algo in self.wallets and self.wallets[algo] is not None:
                    return algo

    def start (self):

        '''
        Main operation loop.
        '''

        self.log('start teamredminer ...', col='y')

        while (True):

            try:
                
                # determine the best algo via API
                self.crawl_whattomine()
                best_algo = self.select_most_profitable_algo()

                # determine if there is a better suiting algorithm,
                # otherwise simply continue mining and do nothing
                if best_algo != self.algo:
                    # if there was an algo selected before, terminate
                    if self.algo is not None:
                        self.log(f'switch to more profitable algorithm: {best_algo}', col='y')
                        self.stop_workload_thread()
                    # overrride and restart
                    self.algo = best_algo
                    self.build_start_command()
                    self.start_workload_thread()
                else:
                    self.log(f'{self.algo} is still the most profitable algorithm, holding ...', col='g')

                # mine for a period
                sleep (period_in_minutes*60)

            except KeyboardInterrupt:

                self.log('terminating.', col='y')
                self.stop_workload_thread()
                break

            except:

                self.log(format_exc(), col='r')

                
    def start_workload_thread (self):

        '''
        Invokes the workload system call as a thread.
        '''

        self.log(f'starting {self.algo} workload ...', col='b')
        self.workload = Process(target=self.sys_call)
        self.workload.start()
        self.pid = self.workload.pid

    def stop_workload_thread (self):

        '''
        Terminates the workload and all unix subprocess i.e. children.
        '''

        self.log(f'terminate {self.algo} workload ...', col='b')
        current_process = psutil.Process(self.pid)
        for child in current_process.children(recursive=True):
            kill(child.pid, SIGTERM)
        self.workload.terminate()

    def sys_call (self):
        
        '''
        Forwards the start command to the system.
        '''

        cmd = self.start_cmd
        #cmd = f"python3 {self.path}/test.py" # for test purposes
        system(cmd)
 
if __name__ == '__main__':   

    w = watchdog(wallets, miner_path)
    w.start()