import matplotlib.pyplot as plt

# Example data for three tasks
tasks = ["Sense", "Think", "Act"]
start_times = [
    [0, 5, 10],  # Start times for Task 1
    [2, 6, 12],  # Start times for Task 2
    [3, 8, 14]   # Start times for Task 3
]
durations = [
    [2, 3, 4],   # Computation times for Task 1
    [1, 2, 2.5], # Computation times for Task 2
    [3, 1.5, 2]  # Computation times for Task 3
]

# Set up the figure and axes for three separate rows
fig, axs = plt.subplots(len(tasks), 1, figsize=(10, 6), sharex=True)

# Loop over each task to create a subplot for each
for i, (task, starts, times) in enumerate(zip(tasks, start_times, durations)):
    for start, duration in zip(starts, times):
        # Plot each computation interval as a vertical line
        axs[i].vlines(x=start, ymin=0.5, ymax=1.5, color="blue", linewidth=duration * 2)  # linewidth proportional to duration
    axs[i].set_ylim(0, 2)  # Keep all vertical lines within the same y-range
    axs[i].set_yticks([])   # Hide y-axis ticks as they don't add information
    axs[i].set_ylabel(task, rotation=0, labelpad=30)  # Label each row with task name

# Common settings
plt.xlabel("Time")
fig.suptitle("Task Computation Time and Intervals")
plt.tight_layout(rect=[0, 0, 1, 0.96])
plt.show()
