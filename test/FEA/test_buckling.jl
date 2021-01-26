using Test
using TopOpt

# Define problem, can also be imported from .inp files
nels = (60,20)
sizes = (1.0,1.0)
E = 1.0;
ν = 0.3;
force = -1.0;
# problem = PointLoadCantilever(nels, sizes, E, ν, force)
problem = PointLoadCantilever(Val{:Linear}, nels, sizes, E, ν, force);
# @show TopOpt.TopOptProblems.getdim(problem)

# Build element stiffness matrices and force vectors
einfo = ElementFEAInfo(problem);

# Assemble global stiffness matrix and force vector
ginfo = assemble(problem, einfo);

# Solve for node displacements
u = ginfo.K \ ginfo.f
# @show u

using TopOpt.TopOptProblems: visualize
visualize(problem, u)
# visualize(problem)

# using GeometryBasics, Makie
# using JuAFEM
# full_topology = ones(Float64, JuAFEM.getncells(problem))
# result_mesh = GeometryBasics.Mesh(problem, full_topology);
# mesh(result_mesh);

# # Get the stiffness matrices for buckling analysis
# K, Kσ = TopOpt.TopOptProblems.buckling(problem, ginfo, einfo)

# using IterativeSolvers

# # Find the maximum eigenvalue of system Kσ x = 1/λ K x
# r = lobpcg(Kσ.data, K.data, true, 1)

# # Minimum eigenvalue of the system K x = λ Kσ x
# λ = 1/r.λ[1]
