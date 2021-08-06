import cProfile
import pstats
import verify_sim_outputs

cProfile.run('verify_sim_outputs.verify_sim_outputs()', 'restats')

p = pstats.Stats('restats')
p.sort_stats('time')
p.print_stats()
