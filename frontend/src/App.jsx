import React, { Fragment, useEffect } from 'react';
import {
  Routes,
  Route,
  useLocation
} from 'react-router-dom';

import './css/style.css';
import './App.css';
import './charts/ChartjsConfig';

// Import pages
import DefaultLayout from './components/layouts/DefaultLayout';
import WorkoutManager from './pages/Workout/WorkoutManager';
import ExercisesManager from './pages/Exercise/ExercisesManager';
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
          const Page = route.component;
          let Layout  = DefaultLayout;

          if(route.layout){
            Layout = route.layout;
          }else if(route.layout === null){
            Layout = Fragment;
          }
           
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
