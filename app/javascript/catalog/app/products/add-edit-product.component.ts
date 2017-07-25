import { Component, ViewChild, Output, EventEmitter, Input } from '@angular/core';
import { ProductService } from './shared/product.service';
import { Product } from './shared/product.model';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { NgForm } from '@angular/forms';
import { ToasterService } from 'angular2-toaster';
import addEditProductTemplateString from'./add-edit-product.component.html';

@Component({
  selector: 'app-add-edit-product',
  template: addEditProductTemplateString
})
export class AddEditProductComponent {

  @Input() updatedProduct;
  product: Product;
  errorMessage: Object = {};
  pageValues: Object = {};

  @ViewChild('newEditProductModal') public newEditProductModal:ModalDirective;
  @Output() resetList:EventEmitter<object[]> = new EventEmitter();
  @Output() updatedProductChange:EventEmitter<object> = new EventEmitter();

  constructor(private productService: ProductService, private toasterService: ToasterService) {
    this.product = new Product();
     this.toasterService = toasterService;
   }

  onSubmit(productForm) {
    this.product.id ? this.updateProduct(productForm) : this.saveProduct(productForm);
  }

  saveProduct(productForm: NgForm) {
    this.productService.saveProduct(this.product)
                      .subscribe(response => {
                        this.refresh(response, productForm);
                        productForm.reset();

                        this.popToast('Product added successfully');
                      },
                       error =>  {
                        this.errorMessage = <any>error;
                      });
  }

  updateProduct(productForm: NgForm) {
    this.productService.updateProduct(this.product)
                    .subscribe(response => {
                      this.refresh(response, productForm);
                      this.popToast('Product updated successfully');
                    },
                    error =>  {
                      this.errorMessage = <any>error;
                    });
  }

  public showNewProductModal():void {
    this.product = new Product();
    this.errorMessage = {};
    this.pageValues = { title: 'New Product', btnTitle: 'Add Product'};
    this.newEditProductModal.show();
  }

  public hideNewEditProductModal(productForm: NgForm):void {
    this.newEditProductModal.hide();
    productForm.reset();
  }

  public showEditProductModal(product):void {
    this.pageValues = { title: 'Edit Product', btnTitle: 'Update Product' };
    this.errorMessage = {};
    this.product =  Object.assign({}, product);
    this.newEditProductModal.show();
  }

  refresh(response, productForm) {
    this.product = response;
    this.updatedProductChange.emit(response.product);
    this.resetList.emit(null);
    this.hideNewEditProductModal(productForm);
  }

  popToast(message) {
    this.toasterService.pop('success', '', message);
  }
}
