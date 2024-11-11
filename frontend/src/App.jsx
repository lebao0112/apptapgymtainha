import React, { useEffect } from 'react';
import {
  Routes,
  Route,
  useLocation
} from 'react-router-dom';

import './css/style.css';

import './charts/ChartjsConfig';

// Import pages
import DefaultLayout from './components/layouts/DefaultLayout';
import WorkoutManager from './pages/WorkoutManager';
import ExercisesManager from './pages/ExercisesManager';
import { privateRoutes } from './routes';

function App() {

  const location = useLocation();

  useEffect(() => {
    document.querySelector('html').style.scrollBehavior = 'auto'
    window.scroll({ top: 0 })
    document.querySelector('html').style.scrollBehavior = ''
  }, [location.pathname]); // triggered on route change

  return (
    <>
      <Routes>
        {privateRoutes.map((route, index) => {
          const Layout = route.layout || DefaultLayout;
          const Page = route.component
          return <Route key={index} path={route.path} element={
            <Layout>
              <Page />
            </Layout>
          } />
        })}
      </Routes>
    </>
  );
}

export default App;
