using TopOpt
import Makie
using TopOpt.TopOptProblems.Visualization: visualize

using FromFile
@from "new_problems.jl" import NewPointLoadCantilever

using TimerOutputs

# function run_topopt()
    println("Start running.")
    # https://github.com/KristofferC/TimerOutputs.jl
    to = TimerOutput()
    reset_timer!(to)
    Nonconvex.show_residuals[] = true

    # Define the problem
    E = 1.0 # Young’s modulus
    v = 0.3 # Poisson’s ratio
    f = 1.0; # downward force

    # Parameter settings
    V = 0.3 # volume fraction
    # xmin = 0.001 # minimum density
    xmin = 1e-6 # minimum density
    rmin = 2.0; # density filter radius

    nels = (20, 10, 2) 
    sizes = (1.0, 1.0, 1.0)
    @timeit to "problem def" problem = NewPointLoadCantilever(Val{:Linear}, nels, sizes, E, v, f);

    # Define a finite element solver
    @timeit to "penalty def" penalty = TopOpt.PowerPenalty(3.0)
    @timeit to "solver def" solver = FEASolver(Displacement, Direct, problem, xmin = xmin,
        penalty = penalty);

    # Define compliance objective
    @timeit to "objective def" begin
        # Define compliance objective
        comp = Compliance(problem, solver)
        filter = DensityFilter(solver, rmin = rmin)
        obj = x -> comp(filter(x))
    end

    # Define volume constraint
    @timeit to "constraint def" begin
        volfrac = TopOpt.Volume(problem, solver)
        constr = x -> volfrac(filter(x)) - V
    end

    # Define subproblem optimizer
    # TODO MMA02 converge to weird results under this criteria
    mma_options = options = Nonconvex.MMAOptions(
        maxiter = 400, 
        tol = Nonconvex.Tolerance(x = 1e-3, f = 1e-6),
        )
    ipopt_options = Nonconvex.IpoptOptions(
        # maxiter = 100, 
        # tol = Nonconvex.Tolerance(x = 1e-3, f = 1e-6),
    )

    convcriteria = Nonconvex.GenericCriteria()
    # convcriteria = Nonconvex.KKTCriteria()

    x0 = fill(V, length(solver.vars))
    @timeit to "optimizer def" optimizer = Optimizer(obj, constr, x0, 
        Nonconvex.MMA87(),
        options = mma_options,
        # Nonconvex.IpoptAlg(),
        # options = ipopt_options,
        convcriteria = convcriteria
        );
    # Nonconvex.MMA02(),

    # Define SIMP optimizer
    @timeit to "simp def" simp = SIMP(optimizer, solver, penalty.p);

    # Solve
    # initial solution, critical to set it to volfrac! (blame non-convexity :)
    @timeit to "simp run" result = simp(x0);

    # Print the timings in the default way
    show(to)
    println()

    @show result.convstate
    @show result.objval
    try
        @show optimizer.workspace.iter
    catch
        # IpoptWorkspace has no field iter
    end

    # # Visualize the result using Makie.jl
    fig = visualize(problem; topology=result.topology, 
        default_exagg_scale=0.07, scale_range=10.0, vector_linewidth=3, vector_arrowsize=0.5)
    Makie.display(fig)

    # return problem, result
# end

# problem, result = run_topopt();