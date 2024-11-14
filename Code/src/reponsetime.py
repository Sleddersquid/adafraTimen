import matplotlib.pyplot as plt
import numpy as np
from pprint import pprint


#  Everything is in milliseconds
task_set_1 = {
    "Sense": { # Task A
        "T": 140, # 50ms
        "C": 100, # xms
        "P": 3
    },
    "Think": { # Task B
        "T": 140, # xms
        "C": 6, # .060ms or 60us
        "P": 2
    },
    "Act": { # Task C
        "T": 140, # xms
        "C": 2, # xms
        "P": 1
    }
}

task_set_2 = {
    "a": { # Task A
        "T": 7, # 50ms
        "C": 3, # 13ms
        "P": 3
    },
    "b": { # Task B
        "T": 12, # 20ms
        "C": 2, # .060ms or 60us
        "P": 2
    },
    "c": { # Task C
        "T": 20, # 10ms
        "C": 5, # 1ms
        "P": 1
    }
}


# def calculate_reponsetime_task_A(task_set: dict) -> int: # Sense
#     return task_set["Sense"]["C"] # Worst case response time for task A, R_a = 13ms


# def calculate_reponsetime_task_B(task_set: dict) -> int: # Think
#     w_b = task_set["Think"]["C"] #  Execution time for task B, C_b = .060ms

#     while True:
#         w_b_next = task_set["Think"]["C"] + np.ceil(w_b / task_set["Think"]["T"]) * task_set["Sense"]["C"]
#         if w_b_next > task_set["Think"]["T"]:
#             return -1
#         if w_b_next == w_b:
#             return w_b # R = w_b
#         w_b = w_b_next


# def calculate_reponsetime_task_C(task_set: dict) -> int: # Act
#     w_c = task_set["Act"]["C"] # Execution time for task C, C_c = 1ms

#     while True:
#         w_c_next = task_set["Act"]["C"] + (
#             np.ceil(w_c / task_set["Sense"]["T"]) * task_set["Sense"]["C"]
#             + np.ceil(w_c / task_set["Think"]["T"]) * task_set["Think"]["C"]
#         )
#         if w_c_next > task_set["Act"]["T"]:
#             return -1
#         if w_c_next == w_c:
#             return w_c # R = w_c
#         w_c = w_c_next


def DISCOMBOBULATED_WHOLE_ASS_TASKSET(task_set: dict) -> dict:
    for current_task in task_set: # For each task
        # print(task_set[current_task]["C"])
        w_i = task_set[current_task]["C"]
        w_i_next = 0

        while True:
            w_i_next = task_set[current_task]["C"]

            for task in task_set:
                if task_set[current_task]["P"] < task_set[task]["P"]:
                    w_i_next += np.ceil(w_i / task_set[task]["T"]) * task_set[task]["C"]

            if w_i_next == w_i: # Valid
                task_set[current_task]["R"] = f"{w_i}" # if valid, set the response time
                break
            if w_i_next > task_set[current_task]["T"]: # Not valid
                task_set[current_task]["R"] = "-1" # If not valid, a negative value is returned
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

pprint(DISCOMBOBULATED_WHOLE_ASS_TASKSET(task_set_1), sort_dicts=False)
print(f"Did it pass the utilization test: {UTILIZATION_TEST(task_set_1)}")

# print(calculate_reponsetime_task_A(task_set))
# print(calculate_reponsetime_task_B(task_set))
# print(calculate_reponsetime_task_C(task_set))
