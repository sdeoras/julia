# steps to setup distributed jupyter notebook
Install `julia` on all nodes in exactly the same way. I do this by moving the
julia folder to `/usr/local/julia` and creating sym-links to binary in `/usr/local/bin`

Follow instructions in this video to install jupyter on master node.
Jupyter installation is only required on the machine that will serve the jupyter notebook.
All other nodes should only install `IJulia` pkg.

Run `Pkg.add("IJulia")` from `julia` REPL on all machines.

Create following startup script for julia on master machine.
Remember to use IP's for your configuration and name this file `startup.jl`
```julia
using Distributed
# use list of tuples to assign worker nodes and number of processes per node
addprocs([("user@wrkr1.node.ip", 1), ("user@wrkr2.node.ip", 1)])
# additionally spin up local processes as required
addprocs(16)
```

Test configuration from master node by running `julia -L startup.jl`
```julia
nprocs()
# should display 19, 1 from master process, 16 worker processes, 1 each on worker nodes.
```

Now prepare a custom kernel for jupyter. On my setup kernels are stored in `${HOME}/.local/share/jupyter/kernels/`
Copy existing julia folder and make two modifications.
* Change display name. Display names are available in jupyter dropdown menu when creating a new file.
* Add `--load=/root/.julia/startupfile.jl` to `argv` list so julia starts by connecting to designated nodes.
```json
{
  "display_name": "Julia 1.0.1 p16",
  "argv": [
    "/usr/local/julia/bin/julia",
    "-i",
    "--load=/root/.julia/startupfile.jl",
    "--color=yes",
    "/root/.julia/packages/IJulia/0cLgR/src/kernel.jl",
    "{connection_file}"
  ],
  "language": "julia"
}
```

After this start jupyter using following command: `jupyter notebook --no-browser --allow-root --ip=master.node.ip`

Create a new notebook, choose the kernel that you just prepared and try running `nprocs()` command to see
if all worker processes are accessible.
