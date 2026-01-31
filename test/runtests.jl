using Test
using RadiationPatterns
using MeshGrid

@testset "RadiationPatterns.jl" begin
    
    # Test Pattern struct creation
    @testset "Pattern Struct" begin
        # Create sample data
        tht = collect(0:10:180)
        phi = collect(0:10:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T)
        
        # Test Pattern creation
        pat = Pattern(U, tht, phi)
        @test pat.U == U
        @test pat.x == tht
        @test pat.y == phi
        @test size(pat.U) == (length(tht), length(phi))
    end
    
    # Test direc function (directivity)
    @testset "Directivity (direc)" begin
        tht = collect(0:10:180)
        phi = collect(0:10:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T) .^ 2
        
        pat = Pattern(U, tht, phi)
        D = direc(pat)
        
        # Directivity should be a real number
        @test D isa Real
        @test D > 0
    end
    
    # Test direc_ptn function (directivity pattern)
    @testset "Directivity Pattern (direc_ptn)" begin
        tht = collect(0:10:180)
        phi = collect(0:10:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T) .^ 2
        
        pat = Pattern(U, tht, phi)
        D_pat = direc_ptn(pat)
        
        # Directivity pattern should be a Pattern object
        @test D_pat isa Pattern
        @test size(D_pat.U) == size(pat.U)
    end
    
    # Test db_ptn function (convert to dB)
    @testset "dB Conversion (db_ptn)" begin
        tht = collect(0:10:180)
        phi = collect(0:10:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T) .^ 2
        
        pat = Pattern(U, tht, phi)
        
        # Test normal dB conversion
        db_pat = db_ptn(pat)
        @test db_pat isa Pattern
        @test size(db_pat.U) == size(pat.U)
        
        # Test dB conversion with power normalization
        db_pat_power = db_ptn(pat, true)
        @test db_pat_power isa Pattern
    end
    
    # Test db_ptn! function (in-place dB conversion)
    @testset "In-place dB Conversion (db_ptn!)" begin
        tht = collect(0:10:180)
        phi = collect(0:10:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T) .^ 2
        
        pat = Pattern(copy(U), tht, phi)
        original_U = copy(pat.U)
        
        # Apply in-place dB conversion
        db_ptn!(pat)
        
        # Check that values have changed (converted to dB)
        @test pat.U != original_U
        @test size(pat.U) == size(original_U)
    end
    
    # Test ptn_2d function
    @testset "2D Pattern Plot (ptn_2d)" begin
        tht = collect(0:10:180)
        phi = collect(0:10:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T) .^ 2
        
        pat = Pattern(U, tht, phi)
        
        # Test normal 2D plot
        p1 = ptn_2d(pat; ind=1, dims=1)
        @test p1 !== nothing
        
        # Test polar 2D plot
        p2 = ptn_2d(pat; type="polar", ind=1, dims=1)
        @test p2 !== nothing
        
        # Test with custom labels and ranges
        p3 = ptn_2d(pat; 
                    ind=1, dims=1,
                    xlabel="Angle", 
                    ylabel="Magnitude",
                    xrange=[0, 180],
                    yrange=[0, 1])
        @test p3 !== nothing
    end
    
    # Test ptn_3d function
    @testset "3D Pattern Plot (ptn_3d)" begin
        tht = collect(0:20:180)
        phi = collect(0:20:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T) .^ 2
        
        pat = Pattern(U, tht, phi)
        
        # Test normal 3D plot
        p1 = ptn_3d(pat)
        @test p1 !== nothing
        
        # Test 3D plot with dB
        p2 = ptn_3d(pat; dB=true, thr=-50)
        @test p2 !== nothing
    end
    
    # Test ptn_holo function
    @testset "Holographic Pattern (ptn_holo)" begin
        tht = collect(0:20:180)
        phi = collect(0:20:360)
        _, T = meshgrid(phi, tht)
        U = sind.(T) .^ 2
        
        pat = Pattern(U, tht, phi)
        
        # Test holographic pattern
        p = ptn_holo(pat)
        @test p !== nothing
    end
    
    # Test multiple patterns comparison
    @testset "Multiple Pattern Comparison" begin
        tht = collect(0:10:180)
        phi = collect(0:10:360)
        _, T = meshgrid(phi, tht)
        
        U1 = sind.(T) .^ 2
        U2 = sind.(T) .^ 3
        
        pat1 = Pattern(U1, tht, phi)
        pat2 = Pattern(U2, tht, phi)
        
        # Test comparing multiple patterns
        p = ptn_2d([pat1, pat2]; ind=[1, 1], dims=[1, 1])
        @test p !== nothing
    end

end
