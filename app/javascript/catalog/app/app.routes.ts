import { RouterModule, Routes } from '@angular/router';
import { ProductsComponent } from './products/products.component';
import { AddEditProductComponent } from './products/add-edit-product.component';

export const ROUTES: Routes = [
  {
    path: '',
    redirectTo: 'products',
    pathMatch: 'full'
  },
  {
    path: 'products',
    component: ProductsComponent
  },
  {
    path: 'products/new',
    component: AddEditProductComponent,
    pathMatch: 'full'
  }
];
