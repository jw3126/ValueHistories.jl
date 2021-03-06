module ValueHistories

using DataStructures
using RecipesBase
using Compat

export

    ValueHistory,
      UnivalueHistory,
        History,
        QHistory,
      MultivalueHistory,
        MVHistory,
    @trace

include("abstract.jl")
include("history.jl")
include("qhistory.jl")
include("mvhistory.jl")
include("recipes.jl")

end # module
