
import ExercisesManager from "../pages/Exercise/ExercisesManager";
import LoginPage from "../pages/Auth/LoginPage";
import DashboardCard01 from "../partials/dashboard/DashboardCard01";

const publicRoutes = [

]

const privateRoutes = [
  { path: "/dashboard", component: DashboardCard01 },
  { path: "/exercises", component: ExercisesManager },
  { path: "/", component: LoginPage, layout: null },
];

export {publicRoutes, privateRoutes}