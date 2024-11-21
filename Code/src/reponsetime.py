import numpy as np
from pprint import pprint

#  Everything is in milliseconds
# Refer to table 3.1 in the report for the task set.
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

# This is for the response time analysis.
# See "Lecture 5 - Response-Time analysis for Fixed Priority Scheduling" for the sudocode
# From the report, this is equation 15
# Reponse time (R) is calulated and is printed to the console. If the response time is -1, it means the task set is not schedulable.
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

# This is for the utilization test.
# See "Lecture 4 - Scheduling" for equation. From the report, this is equation 14 (They the same)
# U is calculated and is printed to the console. Returns True if the task set is passes the utilization test, False otherwise.
def UTILIZATION_TEST(task_set : dict) -> bool:
    Num_processes = len(task_set)
    Utilization = 0

    for task in task_set:
        Utilization += task_set[task]["C"] / task_set[task]["T"]
        task_set[task]["U"] = task_set[task]["C"] / task_set[task]["T"]

    # print(f"Utilization: {Utilization}")
    return Utilization <= Num_processes*(2**(1/Num_processes) - 1)

pprint(RESPONSE_TIME_ANALYSIS(task_set_1), sort_dicts=False)
print(f"Did it pass the utilization test: {UTILIZATION_TEST(task_set_1)}")
