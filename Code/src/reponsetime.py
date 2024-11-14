import matplotlib.pyplot as plt
import numpy as np
from pprint import pprint

#  Everything is in milliseconds
task_set_1 = {
    "Sense": {
        "T": 140,
        "C": 100,
        "P": 3
    },
    "Think": {
        "T": 140,
        "C": 6,
        "P": 2
    },
    "Act": {
        "T": 140,
        "C": 2,
        "P": 1
    }
}

def RESPONSE_TIME_ANALYSIS(task_set: dict) -> dict:
    for current_task in task_set:

        w_i = task_set[current_task]["C"]
        w_i_next = 0

        while True:
            w_i_next = task_set[current_task]["C"]

            for task in task_set:
                if task_set[current_task]["P"] < task_set[task]["P"]:
                    w_i_next += np.ceil(w_i / task_set[task]["T"]) * task_set[task]["C"]

            if w_i_next == w_i:
                task_set[current_task]["R"] = f"{w_i}"
                break
            if w_i_next > task_set[current_task]["T"]:
                task_set[current_task]["R"] = "-1"
                break

            w_i = w_i_next
    return task_set

def UTILIZATION_TEST(task_set : dict) -> bool:
    Num_processes = len(task_set)
    Utilization = 0

    for task in task_set:
        Utilization += task_set[task]["C"] / task_set[task]["T"]
        task_set[task]["U"] = task_set[task]["C"] / task_set[task]["T"]

    print(f"Utilization: {Utilization}")
    return Utilization <= Num_processes*(2**(1/Num_processes) - 1)

pprint(RESPONSE_TIME_ANALYSIS(task_set_1), sort_dicts=False)
print(f"Did it pass the utilization test: {UTILIZATION_TEST(task_set_1)}")
