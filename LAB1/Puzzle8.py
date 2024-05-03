class Puzzle8:
    def __init__(self, initial_state, goal_state):
        self.initial_state = initial_state
        self.goal_state = goal_state
    
    def display_state(self, state):
        for row in state:
            print(" ".join(map(str, row)))
        print()
    
    def get_empty_tile_position(self, state):
        for i in range(3):
            for j in range(3):
                if state[i][j] == 0:
                    return i, j
    
    def generate_successors(self, state):
        successors = []
        empty_i, empty_j = self.get_empty_tile_position(state)
        moves = [(0, 1), (1, 0), (0, -1), (-1, 0)]  # Right, Down, Left, Up
        for move in moves:
            new_i, new_j = empty_i + move[0], empty_j + move[1]
            if 0 <= new_i < 3 and 0 <= new_j < 3:
                new_state = [row.copy() for row in state]
                new_state[empty_i][empty_j], new_state[new_i][new_j] = new_state[new_i][new_j], new_state[empty_i][empty_j]
                successors.append(new_state)
        return successors
    
    def goal_test(self, state):
        return state == self.goal_state
    
    def iterative_deepening_search(self):
        depth = 0
        while True:
            result = self.depth_limited_search(self.initial_state, depth)
            if result == "goal":
                print("Goal state found!")
                return
            elif result == "cutoff":
                print(f"Reached depth limit {depth}, increasing depth...")
                depth += 1
            else:
                print("Initial state not reachable.")
                return
    
    def depth_limited_search(self, state, depth_limit):
        if self.goal_test(state):
            self.display_state(state)
            return "goal"
        if depth_limit == 0:
            return "cutoff"
        cutoff_occurred = False
        for successor in self.generate_successors(state):
            result = self.depth_limited_search(successor, depth_limit - 1)
            if result == "goal":
                self.display_state(state)
                return "goal"
            elif result == "cutoff":
                cutoff_occurred = True
        return "cutoff" if cutoff_occurred else "failure"

# Example Usage:
initial_state = [
    [1, 2, 3],
    [4, 0, 6],
    [7, 5, 8]
]
goal_state = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 0]
]
puzzle = Puzzle8(initial_state, goal_state)
puzzle.iterative_deepening_search()
