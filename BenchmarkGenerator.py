import random
import math
import os

class Graph:
    def __init__(self, n, m):
        self.n = n
        self.m = m
        self.max_km_per_day = random.randint(50, 100)
        self.graph = self.generate_graph()

    def generate_graph(self):
        return [(i, (i+1)%self.n, random.randint(1, math.floor(self.max_km_per_day/2))) for i in range(self.n)]

    def is_valid_edge(self, a, b, generated_edges):
        not_adjacent = abs(a - b) != 1 and abs(a - b) != self.n-1
        not_in_graph = (a, b) not in self.graph and (b, a) not in self.graph
        not_generated = (a, b) not in generated_edges and (b, a) not in generated_edges
        return not_adjacent and not_in_graph and not_generated

    def add_random_edges(self):
        generated_edges = set()
        while len(generated_edges) < self.m:
            a, b = random.sample(range(self.n), 2)
            if self.is_valid_edge(a, b, generated_edges):
                self.graph.append((a, b, random.randint(1, math.floor(self.max_km_per_day/2))))
                generated_edges.add((a, b))

    def to_ASP_input(self, f):
        f.write(f"day(1..{self.m+self.n}).\n")
        f.write(f"roadsTraveledPerDay(1..{(self.n * 2)-1}).\n")
        f.write(f"#const max_km_per_day = {self.max_km_per_day}.\n")
        for a, b, length in self.graph:
            f.write(f"road({a+1}, {b+1}, {length}).\n") 
            f.write(f"road({b+1}, {a+1}, {length}).\n")

    def to_minizinc_input(self, f):
        distance = [[0]*self.n for _ in range(self.n)]
        for a, b, length in self.graph:
            distance[a][b] = length
            distance[b][a] = length
        distance_str = '|\n'.join(' , '.join(str(cell) for cell in row) for row in distance)
        distance_str = '[| ' + distance_str + ' |]'
        f.write(f"intersections = {self.n};\n")
        f.write(f"max_km_per_day = {self.max_km_per_day};\n")
        f.write(f"distance = {distance_str};\n")

    def generate(self, fileName):
        self.add_random_edges()
        directory = 'Benchmark_Instances/'
        if not os.path.exists(directory):
            os.makedirs(directory)
        with open(os.path.join(directory, fileName), 'w') as f:
            f.write("ASP Input:\n")
            self.to_ASP_input(f)
            f.write("\nMiniZinc Input:\n")
            self.to_minizinc_input(f)

graph = Graph(n=11, m=2)
graph.generate("hard5.txt")
