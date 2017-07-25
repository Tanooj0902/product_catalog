import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { HttpModule }  from '@angular/http';
import { ModalModule } from 'ngx-bootstrap';
import { CurrencyPipe } from '@angular/common';
import { InfiniteScrollModule } from 'ngx-infinite-scroll'
import { AppComponent } from './app.component';
import { ProductsComponent } from './products/products.component';
import { ProductService } from './products/shared/product.service';
import { ROUTES } from './app.routes';
import { AddEditProductComponent } from './products/add-edit-product.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToasterModule } from 'angular2-toaster';

@NgModule({
  declarations: [
    AppComponent,
    ProductsComponent,
    AddEditProductComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    RouterModule.forRoot(ROUTES),
    ModalModule.forRoot(),
    InfiniteScrollModule,
    BrowserAnimationsModule,
    ToasterModule
  ],
  providers: [ ProductService, CurrencyPipe ],
  bootstrap: [AppComponent]
})
export class AppModule { }
