import cProfile
import pstats
import  generate_sim_inputs

cProfile.run('generate_sim_inputs.generate_sim_inputs()', 'restats')

p = pstats.Stats('restats')
p.sort_stats('time')
p.print_stats()