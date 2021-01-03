function no_slip_bc(grid2D)

   v_bcs = VVelocityBoundaryConditions(grid2D.grid,
              top = BoundaryCondition(Value, 0.0),
           bottom = BoundaryCondition(Value, 0.0),
            north = BoundaryCondition(NormalFlow, 0.0),
            south = BoundaryCondition(NormalFlow, 0.0)
   )
   w_bcs = WVelocityBoundaryConditions(grid2D.grid,
           north = BoundaryCondition(Value, 0.0),
           south = BoundaryCondition(Value, 0.0),
             top = BoundaryCondition(NormalFlow, 0.0),
          bottom = BoundaryCondition(NormalFlow, 0.0)
   )

   return v_bcs, w_bcs
end
