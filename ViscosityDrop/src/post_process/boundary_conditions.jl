function no_slip_bc(grid)
   v_bcs = VVelocityBoundaryConditions(grid,
              top = BoundaryCondition(Value, 0.0),
           bottom = BoundaryCondition(Value, 0.0),
            north = BoundaryCondition(NormalFlow, 0.0),
            south = BoundaryCondition(NormalFlow, 0.0))
   w_bcs = WVelocityBoundaryConditions(grid,
           north = BoundaryCondition(Value, 0.0),
           south = BoundaryCondition(Value, 0.0),
             top = BoundaryCondition(NormalFlow, 0.0),
          bottom = BoundaryCondition(NormalFlow, 0.0))
   return v_bcs, w_bcs
end
