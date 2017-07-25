import { Component, OnInit } from '@angular/core';
import { ProductService } from './shared/product.service';
import { Product } from './shared/product.model';
import { ToasterService } from 'angular2-toaster';
import productsTemplateString from './products.component.html';

@Component({
  selector: 'app-products',
  template: productsTemplateString
})
export class ProductsComponent implements OnInit {

  products: Product[] = [];
  product: Product;
  page: number = 1;
  total_pages: number;

  constructor(private productService: ProductService, private toasterService: ToasterService) {
    this.toasterService = toasterService;
  }

  ngOnInit() {
    this.productList();
  }

  productList() {
    this.productService.getProducts(this.page)
                      .subscribe(response => {
                        this.products = this.products.concat(response.products);
                        this.total_pages = response.meta.total_pages;
                      });
  }

  showProductDetail(product) {
    this.product = product;
  }

  destroyProduct(product) {
    this.productService.deleteProduct(product)
                      .subscribe(response => {
                        this.resetList();
                        this.product = null;
                        this.popToast('Product deleted successfully');
                      });
  }

  onScroll() {
    if(this.page < this.total_pages) {
      this.page = this.page + 1;
      this.productList();
    }
	}

  resetList() {
    this.products = [];
    this.page = 1;
    this.productList();
  }

  popToast(message) {
    this.toasterService.pop('success', '', message);
  }
}
