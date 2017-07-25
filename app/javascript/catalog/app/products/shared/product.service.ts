import { Injectable } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import { Product } from './product.model';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';

@Injectable()
export class ProductService {

  private options;
  private productApiUrl = '/api/v1/products';
  
  constructor(private http: Http) {
    let headers = new Headers({ 'Content-Type': 'application/json'});
    this.options = new RequestOptions({ headers: headers });
   }

  saveProduct(product: Product): Observable<Product> {
    let body = { product: product };
    return this.http
              .post(this.productApiUrl, JSON.stringify(body), this.options)
              .map(response => response.json() as Product)
              .catch((error:any) => Observable.throw(error.json().errors || 'Server error'));
    
  }

  getProducts(page): Observable<any> {
    let url = `${this.productApiUrl}?page=${page}`;
    return this.http
              .get(url)
              .map(response => response.json());
  }

  updateProduct(product: Product): Observable<Product> {
    let url = `${this.productApiUrl}/${product.id}`;
    let body = { product: product };
    return this.http
              .put(url, JSON.stringify(body), this.options)
              .map(response => response.json() as Product)
              .catch((error:any) => Observable.throw(error.json().errors || 'Server error'));
  }

  deleteProduct(product: Product): Observable<Product>  {
    let url = `${this.productApiUrl}/${product.id}`;
    return this.http
              .delete(url, this.options)
              .map(response => response.json());
  }

}
