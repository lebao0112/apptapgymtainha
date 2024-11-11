import ExercisesManager from "../pages/ExercisesManager";
import DashboardCard01 from "../partials/dashboard/DashboardCard01";

const publicRoutes = [

]

const privateRoutes = [
  { path: "/", component: DashboardCard01 },
  { path: "/exercises", component: ExercisesManager },
];

export {publicRoutes, privateRoutes}