import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SujetsList } from './sujets-list';

describe('SujetsList', () => {
  let component: SujetsList;
  let fixture: ComponentFixture<SujetsList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SujetsList]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SujetsList);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
